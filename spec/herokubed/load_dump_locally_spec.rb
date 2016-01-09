require 'herokubed/load_dump_locally'

module Herokubed
  describe LoadDumpLocally do
    describe '.load' do
      context 'invalid parameters' do
        let(:params) {''}

        before do
          allow(Herokubed).to receive(:spawn_command)
          allow(LoadDumpLocally).to receive(:puts)
          allow(LoadDumpLocally).to receive(:exit)
          LoadDumpLocally.load(*params.split)
        end

        context 'when no parameters' do
          it 'puts a usage message' do
            expect(LoadDumpLocally).to have_received(:puts).with LOAD_USAGE_MESSAGE
          end

          it 'exits as failed' do
            expect(LoadDumpLocally).to have_received(:exit).with(false)
          end
        end
      end

      context 'happy path with valid parameters' do
        let(:params) { 'fake-app-name fake-db-name' }
        before do
          allow(Herokubed).to receive(:spawn_command)
          LoadDumpLocally.load(*params.split)
        end

        it 'drops the target db' do
          expect(Herokubed).to have_received(:spawn_command).with "dropdb fake-db-name"
        end

        it 'creates the target db' do
          expect(Herokubed).to have_received(:spawn_command).with "createdb fake-db-name"
        end

        it 'executes the pg_restore command' do
          expected_command = "pg_restore --verbose --clean --no-acl --no-owner -d fake-db-name .dbwork/fake-app-name.dump"
          expect(Herokubed).to have_received(:spawn_command).with expected_command
        end
      end
    end
  end

  LOAD_USAGE_MESSAGE = %q(
Loads a postgres dump file from an heroku application
to a local postgres database. Assumes that kbackupdb
has been used successfully to create a .dbwork/<app_name>.dump file.
WARNING: overwrites the local database.

Usage: kloaddumplocally source_app_name target_local_database
)
end