require 'herokubed/herokubed_backup'
require 'fileutils'

module Herokubed
  describe Backup do
    describe '.backup_db' do
      context 'without valid input' do
        before do
          allow(Herokubed).to receive(:spawn_command)
          allow(Dir).to receive(:mkdir)
          allow(Dir).to receive(:exists?)
          allow(Herokubed::Backup).to receive(:puts)
          allow(Herokubed::Backup).to receive(:exit)
          Herokubed::Backup.backup_db(*params.split)
        end

        context 'too many params' do
          let(:params) { 'bob jerome nancy' }

          it 'exits as failed' do
            expect(Herokubed::Backup).to have_received(:exit).with(false)
          end

          it 'puts a usage message' do
            expect(Herokubed::Backup).to have_received(:puts).with %q(
Creates a dump file of a postgres database from an heroku
application, and downloads that file to .dbwork/<app_name>.dump.
If there is an existing .dbwork/<app_name>.dump file, that file will
be renamed to .dbwork/<app_name>.dump.<create_date>

Usage: kbackupdb source_app_name
)
          end
        end
      end

      context 'with valid input' do
        let(:dbwork_exists) { true }
        let(:app_name) { 'bob_the_app' }
        let(:previous_dump_exists) { false }
        let(:previous_dump_mtime) { Time.now - 300 }

        before do
          allow(File).to receive(:exists?).with('.dbwork/bob_the_app.dump').and_return previous_dump_exists
          allow(File).to receive(:mtime).with('.dbwork/bob_the_app.dump').and_return previous_dump_mtime
          allow(FileUtils).to receive(:mv)
          allow(Herokubed).to receive(:spawn_command)
          allow(Dir).to receive(:mkdir)
          allow(Dir).to receive(:exists?).with('.dbwork').and_return dbwork_exists
          Herokubed::Backup.backup_db app_name
        end

        context 'when previous dump file has been downloaded' do
          let(:previous_dump_exists) { true }

          it 'renames the file with an extension representing the last modified time' do
            expected_file_name = ".dbwork/bob_the_app.dump.#{previous_dump_mtime.strftime('%Y%m%d_%H%M%S')}"
            expect(FileUtils).to have_received(:mv).with('.dbwork/bob_the_app.dump', expected_file_name)
          end
        end

        it 'spawns a command to create the backup' do
          expect(Herokubed).to have_received(:spawn_command).with 'heroku pg:backups capture --app bob_the_app'
        end

        it 'spawns a command to download the backup' do
          expect(Herokubed).to have_received(:spawn_command).with 'curl -o .dbwork/bob_the_app.dump `heroku pg:backups public-url --app bob_the_app`'
        end

        context 'when the .dbwork directory does not exist' do
          let(:dbwork_exists) { false }

          it 'creates the .dbwork directory' do
            expect(Dir).to have_received(:mkdir).with('.dbwork')
          end
        end

        context 'when the .dbwork directory already exists' do
          it 'does not create a .dbwork directory' do
            expect(Dir).not_to have_received(:mkdir).with('.dbwork')
          end
        end
      end
    end
  end
end