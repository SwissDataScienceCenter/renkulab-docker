import os

xstartup = 'dbus-launch xfce4-session'

vnc_socket = os.path.join(os.getenv('HOME'), '.vnc', 'socket')

noVNC_version = '1.1.0'

c.ServerProxy.servers = {
    'vnc': {
        'command': [
            '/opt/conda/bin/websockify',
            '-v',
            '--web', '/opt/noVNC-' + noVNC_version,
            '--heartbeat', '30',
            '5901',
            '--unix-target', vnc_socket,
            '--',
            'vncserver',
            '-verbose',
            '-xstartup', xstartup,
            '-geometry', '1024x768',
            '-SecurityTypes', 'None',
            '-rfbunixpath', vnc_socket,
            '-fg',
            ':1'
        ],
        'absolute_url': False,
        'port': 5901,
        'timeout': 10,
        'mappath': {'/': '/vnc_renku.html'},
        'launcher_entry': {
            'enabled': True,
            'title': 'VNC'
        }
    }
}

