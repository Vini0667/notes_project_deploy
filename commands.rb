#!/usr/bin/env ruby

require 'optparse'
require 'fileutils'

PROJECT_ROOT = File.expand_path("..", __dir__)
FRONTEND_DIR = File.join(PROJECT_ROOT, 'notes_project_frontend')
BACKEND_DIR = File.join(PROJECT_ROOT, 'notes_project_backend')

FRONTEND_REPO = 'git@github.com:Vini0667/notes_project_frontend.git'
BACKEND_REPO = 'git@github.com:Vini0667/notes_project_backend.git'

def run_command_no_exit(full_command, dir: nil)
    puts "\nAttempting: #{full_command}"

    options = {}

    options[:chdir] = dir if dir

    system(full_command, options)
end

def run_and_check(full_command, dir: nil)
    puts "\nAttempting: #{full_command}"

    options = {}

    options[:chdir] = dir if dir

    success = system(full_command, options)

    unless success
        puts "\nCommand failed"
        exit 1
    end
end

def ensure_repo_and_install(dir_path, repo_url, install_command)
    dir = File.expand_path(dir_path)

    if (File.directory?(dir_path))
        puts 'Directory already exists'
    else
        puts "Directory #{dir} not found, creating..."
        run_and_check("git clone #{repo_url}", dir: PROJECT_ROOT)
        run_and_check('git switch dev', dir: dir)
    end

    puts 'Installing dependencies...'
    run_and_check(install_command, dir: dir)
    puts "Dependencies for #{dir} installed successfully"
end

def main
    command = nil

    parser = OptionParser.new do |opts|
        opts.banner = "Usage: ruby commands.rb [COMMAND] [OPTIONS]"

        opts.separator ""
        opts.separator "Available Commands:\t\tUsage:"
        opts.separator "  up\t\t\t\tStarts the deployment"
        opts.separator "  down\t\t\t\tStops the deployment"

        opts.separator "Avaible options:"
        opts.on("-h", "--help", "Prints this help message") do
            puts opts
            exit
        end
    end

    if ARGV.include?('-h') || ARGV.include?('--help') || ARGV.include?('help') || ARGV.empty?
        puts parser.help
        exit
    end

    command = ARGV.shift
    parser.parse!(ARGV) rescue nil

    # puts ARGV.shift

    case command
    when "up"
        puts "Starting deployment..."
        ensure_repo_and_install(FRONTEND_DIR, FRONTEND_REPO, 'npm install')
        ensure_repo_and_install(BACKEND_DIR, BACKEND_REPO, 'yarn install')

        puts "Starting containers..."

        if run_command_no_exit('podman-compose -f ./compose-dev.yml up -d')
            puts "Containers started successfully via Podman"
        elsif run_command_no_exit('docker compose -f ./compose-dev.yml up -d')
            puts "Containers started successfully via Docker compose"
        else
            warn "Error starting containers"
            exit 1
        end
    when "down"
        puts "Stopping deployment..."
        if run_command_no_exit('podman-compose -f ./compose-dev.yml down')
            puts "Stopped containers via Podman-compose"
        elsif run_command_no_exit('docker compose -f ./compose-dev.yml down')
            puts "Stopped containers via Docker compose"
        else
            warn "Error stopping containers"
            exit 1
        end
    else
        puts "Error: Unknown command: {#{command}}"
        puts parser.help
        exit 1
    end
end

main
