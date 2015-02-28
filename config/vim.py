import config
import os
import subprocess


class ConfigVim(config.Config):
    def repo(self):
        return os.path.join(os.getenv('HOME'), 'repo')

    def source_dir(self):
        return os.path.join(self.repo(), 'vim_script')

    def pre(self):
        def make_if_not_exist(path):
            if not os.path.exists(path):
                os.mkdir(path)

        make_if_not_exist(self.repo())
        subprocess.call(
            ['git', 'clone', 'https://github.com/sgkim126/vim_script.git',
                self.source_dir()])
        os.chdir(self.source_dir())
        subprocess.call(['git', 'submodule', 'init'])
        subprocess.call(['git', 'submodule', 'update'])

    def post(self):
        vim_dir = os.path.join(os.getenv('HOME'), '.vim')
        os.symlink(self.source_dir(), vim_dir)
        subprocess.call(['vim', '+PlugInstall', '+qall'])
