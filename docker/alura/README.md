# Docker

|Folder     |Tools|
|-------------|-----------|
|`1.Alura`| Docker
|`2.Alura`| Docker Swarm & Docker Machine

Pré requisito:


Download Docker:<br>
&nbsp;&nbsp;&nbsp;&nbsp;https://www.docker.com/products/docker-desktop

Comandos WSL:<br>
&nbsp;&nbsp;&nbsp;&nbsp;https://docs.microsoft.com/pt-br/windows/wsl/install-manual 

Instalação Docker Ubuntu:<br>
```
$ sudo apt-get remove docker docker-engine docker.io
$ sudo apt-get update
$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
$ sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
$ sudo apt-get update
$ sudo apt-get install docker-ce
$ sudo docker version
$ sudo usermod -aG docker $(whoami)

$ sudo curl -L https://github.com/docker/compose/releases/download/1.15.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
$ sudo chmod +x /usr/local/bin/docker-compose

$ curl -L https://github.com/docker/machine/releases/download/v0.16.2/docker-machine-`uname -s`-`uname -m` >/tmp/docker-machine && chmod +x /tmp/docker-machine && sudo cp /tmp/docker-machine /usr/local/bin/docker-machine
```

Instalação Docker Machine Git BASH:<br>
```
$ base=https://github.com/docker/machine/releases/download/v0.16.0 &&
  mkdir -p "$HOME/bin" &&
  curl -L $base/docker-machine-Windows-x86_64.exe > "$HOME/bin/docker-machine.exe" &&
  chmod +x "$HOME/bin/docker-machine.exe"

$ docker-machine version

$ docker-machine version 0.16.0, build 9371605
```

|Tool    |Link|
|-------------|-----------|
|`Docker`| https://desktop.docker.com/win/stable/amd64/Docker%20Desktop%20Installer.exe
|`Git BASH`| https://github.com/git-for-windows/git/releases/download/v2.34.1.windows.1/Git-2.34.1-64-bit.exe
|`WSL`| https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi
|`VirtualBox`| https://download.virtualbox.org/virtualbox/6.1.30/VirtualBox-6.1.30-148432-Win.exe