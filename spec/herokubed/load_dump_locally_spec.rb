require 'herokubed/load_dump_locally'

module Herokubed
  describe LoadDumpLocally do
    describe '.load_db' do
      context 'dump file does not exist' do
        let(:params) {'fake-app fake-db'}

        before do
          allow(Herokubed).to receive(:spawn_command)
          allow(LoadDumpLocally).to receive(:puts)
          allow(File).to receive(:exists?).and_return false
          begin
            LoadDumpLocally.load_db(*params.split)
            raise 'expected exit did not occur'
          rescue SystemExit => e
            @exited = e
          end
        end

        it 'exits as failed' do
          expect(@exited.status).to be > 0
        end

        it 'puts a message' do
          expect(LoadDumpLocally).to have_received(:puts).with LoadDumpLocally::DUMP_FILE_MISSING_MESSAGE
        end
      end

      context 'invalid parameters' do
        let(:params) { '' }

        before do
          allow(File).to receive(:exists?).and_return true
          allow(Herokubed).to receive(:spawn_command)
          allow(LoadDumpLocally).to receive(:puts)
          begin
            LoadDumpLocally.load_db(*params.split)
            raise 'expected exit did not occur'
          rescue SystemExit => e
            @exited = e
          end
        end

        context 'when no parameters' do
          it 'exits as failed' do
            expect(@exited.status).to be > 0
          end

          it 'puts a message' do
            expect(LoadDumpLocally).to have_received(:puts).with LoadDumpLocally::USAGE_MESSAGE
          end
        end
      end

      context 'happy path with valid parameters' do
        let(:params) { 'fake-app-name fake-db-name' }
        before do
          allow(File).to receive(:exists?).and_return true
          allow(Herokubed).to receive(:spawn_command)
          LoadDumpLocally.load_db(*params.split)
        end

        it 'checks for the existence of the dump file' do
          expect(File).to have_received(:exists?).with '.dbwork/fake-app-name.dump'
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
end