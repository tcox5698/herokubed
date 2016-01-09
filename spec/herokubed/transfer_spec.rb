require 'herokubed/transfer'

module Herokubed
  describe Transfer do

    shared_examples_for 'an incorrect ktransferdb usage' do
      it 'puts a usage message' do
        expect(Herokubed::Transfer).to have_received(:puts).with %q(
Transfers a postgres database from one heroku
application to another, overwriting the postgres
database of the second application.

Usage: ktransferdb source_app_name target_app_name
)
      end

      it 'exits as failed' do
        expect(Herokubed::Transfer).to have_received(:exit).with(false)
      end
    end

    describe '.transfer_db' do
      before do
        allow(Herokubed::Transfer).to receive(:exit)
        allow(Herokubed::Transfer).to receive(:puts)
        allow(Herokubed).to receive(:spawn_command)
        allow(Herokubed).to receive(:database_url).and_return 'fake_db_url'
        Herokubed::Transfer.transfer_db(*params.split)
      end

      context 'with two parameters' do
        let(:params) { 'one_param two_param' }

        context 'happy path' do
          it 'uses the source app_name to get the source database_url' do
            expect(Herokubed).to have_received(:database_url).with('one_param')
          end

          it 'performs a command line copy' do
            expected_command = 'heroku pg:copy fake_db_url DATABASE_URL --app two_param --confirm two_param'
            expect(Herokubed).to have_received(:spawn_command).with(expected_command)
          end
        end
      end

      context 'with more than two parameters' do
        let(:params) { 'one_param two_param three_param' }
        it_behaves_like 'an incorrect ktransferdb usage'
      end

      context 'with insufficient parameters' do
        let(:params) { 'one_param' }
        it_behaves_like 'an incorrect ktransferdb usage'
      end

      context 'with no parameters' do
        let(:params) { '' }
        it_behaves_like 'an incorrect ktransferdb usage'
      end
    end

  end
end