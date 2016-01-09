require 'herokubed/load_dump_locally'

module Herokubed
  describe LoadDumpLocally do
    describe '.load' do
      context 'happy path with valid input' do
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
end