# Repositório de Deploy

Este repositório contém os arquivos de configuração e scripts necessários para implantar o projeto Notes em um servidor web.


## A fazer
- Escrever alguns scripts para automatizar a implantação do projeto em outra máquina. OK
- Documentação

## Script, como usar

O script __commands.rb__ é responsável pela instalação e por subir o projeto na máquina de um novo colaborador.
Para usar o script, execute o comando abaixo:

### Requerimentos
- Ruby 2.7 ou superior
- Docker ou Podman&Podman-Compose

```
ruby commands.rb up
ruby commands.rb down
```
