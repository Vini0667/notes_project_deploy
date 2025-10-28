# Repositório de Deploy

Este repositório contém os arquivos de configuração e scripts necessários para implantar o projeto Notes em um servidor web.


## A fazer
- Escrever alguns scripts para automatizar a implantação do projeto em outra máquina. OK
- Documentação

## Script, como usar

O script __commands.rb__ é responsável pela instalação e por subir o projeto na máquina de um novo colaborador.
Para usar o script, execute o comando abaixo:

### Requerimentos
- Ruby
- Docker ou Podman&Podman-Compose

### Como usar

Subir aplicação
```
ruby commands.rb up
```
Parar aplicação
```
ruby commands.rb down
```
