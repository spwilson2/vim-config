from __future__ import print_function

import os
import time
import subprocess
import json
import functools
import threading
import socket
import socketserver

_print = print
def print(*args):
    with open('log', 'a') as f:
        _print(*args, file=f)

# Seconds
TICK_TIME = .1
SERVER_NAME = '/tmp/vim-server'
CLIENT_NAME = '/tmp/vim-client'

class Message:
    def __init__(self, name, **kwargs):
        self.data = {'msg': name}
        self.data.update(kwargs)

    @property
    def name(self):
        return self.data['msg']

    def serialize(self):
        return json.dumps(self.data).encode('utf-8')

    @classmethod
    def deserialize(cls, data):
        data = json.loads(data.decode('utf-8'))
        if not data.get('msg'):
            return None
        return cls(data['msg'], **data)


class ServerConnection:
    def __init__(self, servername):
        self._address = servername
        self._socket = None

    def start_or_connect(self):
        if self._socket:
            return True

        if not self.connect():
            print('Server not found, starting one...')
            self.start()
            while not self.connect():
                time.sleep(TICK_TIME)
        return True

    def start(self):
        null = open('/dev/null', 'w')
        #self.server = subprocess.Popen(['python', 'server.py', SERVER_NAME], stdout=null, stderr=null)
        self.server = subprocess.Popen(['python', 'server.py', SERVER_NAME])

    def connect(self):
        if self._socket:
            return True

        self._socket = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        try:
            self._socket.connect(self._address)
            return True
        except (FileNotFoundError, ConnectionRefusedError, OSError):
            self._socket.close()
            self._socket = None
        return False

    def send(self, data):
        try:
            self._socket.send(data)
        except BrokenPipeError:
            self._socket = None
            raise

    def send_heartbeat(self, client):
        msg = Message('hearbeat', client=client)
        self._socket.send(msg.serialize())

        data = self._socket.recv(1024)
        msg = Message.deserialize(data)
        return msg.name == 'heatbeat-ack'

    def send_active(self, client):
        print('sending active')
        msg = Message('active', client=client)
        print(msg.serialize())
        self._socket.send(msg.serialize())

        data = self._socket.recv(1024)
        msg = Message.deserialize(data)
        return msg.name == 'active-ack'

class PluginHookManager(object):
    def __init__(self, obj):
        self.hooks = {}
        self.obj = obj
        self.initialize_hooks()

    def handle(self, hook):
        if hook in self.hooks:
            for func in self.hooks[hook]:
                func()

    def initialize_hooks(self):
        for attr in dir(self.obj):
            func = getattr(self.obj, attr)
            if hasattr(func, '_plugin_hook'):
                name = func._plugin_hook['name']
                self.hooks.setdefault(name, [])
                self.hooks[name].append(func)

class Plugin:
    _plugins = []
    _plugin_hooks = []
    _registered_hooks = set([])
    _active_plugins = []

    @classmethod
    def plugin(cls, plugin_cls):
        cls.wrap_init(plugin_cls)
        return plugin_cls

    @staticmethod
    def _add_vim_hook(vim, name):
        vim.command('au {name} * py3 plugin.Plugin.handle("{name}")'.format(name=name))

    @classmethod
    def initialze_plugin_hooks(cls, vim):
        # Create the plugin objects from their respective classes
        plugins = []
        for plugin in cls._plugins:
            plugins.append(plugin(vim))
        cls._active_plugins = plugins

        for manager in cls._plugin_hooks:
            manager.initialize_hooks()

        vim.command('augroup MyEditor')
        vim.command('au!')
        for hook in cls._registered_hooks:
            cls._add_vim_hook(vim, hook)
        vim.command('augroup END')

    @classmethod
    def wrap_init(cls, plugin_cls):
        og_init = plugin_cls.__init__
        cls._plugins.append(plugin_cls)
        def wrap(_self, *args, **kwargs):
            cls._plugin_hooks.append(PluginHookManager(_self))
            return og_init(_self, *args, **kwargs)
        plugin_cls.__init__ = wrap

    @classmethod
    def autocommand(cls, name):
        cls._registered_hooks.add(name)
        def wrap(func):
            func._plugin_hook = { 'name': name }
            return func
        return wrap

    @classmethod
    def handle(cls, hook):
        for hook_manager in cls._plugin_hooks:
            hook_manager.handle(hook)


class RepeatTimer():
    def __init__(self, time, callback):
        self.time = time
        self.callback = callback
        self.shutdown = threading.Event()
        self._thread = threading.Thread(target=self._start)
        self._thread.setDaemon(True)

    def stop(self):
        self.shutdown.set()

    def start(self):
        self._thread.start()

    def _start(self):
        while not self.shutdown.wait(self.time):
            self.callback()

# NOTE Technically unsafe when using vim
# Not sure how to go about forcing a command to run on the main thread.
def async_call(vim, cmd):
    if hasattr(vim, 'async_call'):
        vim.async_call(lambda: vim.command(cmd))
    else:
        vim.command(cmd)

class Handler(socketserver.BaseRequestHandler):
    _plugin = None
    def handle(self):
        data = self.request[0]
        data = Message.deserialize(data)
        if data.name == 'command':
            print('command: ', data.data['cmd'])
            async_call(vim, data.data['cmd'])

@Plugin.plugin
class TestPlugin:
    def __init__(self, vim):
        self.vim = vim

        self.client_name = CLIENT_NAME
        # TODO Start our own server in the background for running arbitrary
        # commands
        self._client = threading.Thread(target=self.clientserver)
        self._client.daemon = True
        self._client.start()

        self.active = threading.Event()
        self.connection = ServerConnection(SERVER_NAME)
        self.timer = RepeatTimer(TICK_TIME, self.handle_timer)
        self.timer.start()


    def clientserver(self):
        Handler._plugin = self
        if os.path.exists(self.client_name):
            os.unlink(self.client_name)
        with socketserver.UnixDatagramServer(self.client_name, Handler) as s:
            s.serve_forever()

    def testcommand(self, args, range):
        self.vim.current.line = ('Command with args: {}, range: {}'
                                  .format(args, range))

    @Plugin.autocommand('FocusGained')
    def on_focus_gained(self):
        self.active.set()

    @Plugin.autocommand('CursorMoved')
    def on_cursor_n(self):
        self.active.set()

    @Plugin.autocommand('CursorMovedI')
    def on_cursor_i(self):
        self.active.set()

    def handle_timer(self):
        available = self.connection.start_or_connect()
        if not available:
            return

        self.connection.send_heartbeat(self.client_name)
        if self.active.is_set():
            self.connection.send_active(self.client_name)
            self.active.clear()

def plugin_init(vim):
    Plugin.initialze_plugin_hooks(vim)



try:
    import vim
    print('Init')
    plugin_init(vim)
except ImportError:
    pass

if __name__ == '__main__':
    class MockVim():
        def command(self, cmd):
            print('Running cmd: %s' % cmd)
    plugin_init(MockVim())
