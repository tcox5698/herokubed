require 'herokubed'

describe Herokubed do

  shared_examples_for 'an incorrect commandline usage' do
    it 'puts a usage message' do
      expect(Herokubed).to have_received(:puts).with %q{
Transfers a postgres database from one heroku
application to another, overwriting the postgres
database of the second application.

Usage: ktransferdb source_app_name target_app_name
}
    end

    it 'exits as failed' do
      expect(Herokubed).to have_received(:exit).with(false)
    end
  end

  describe '.ktransferdb' do
    before do
      allow(Herokubed).to receive(:exit)
      allow(Herokubed).to receive(:puts)
      allow(Herokubed).to receive(:spawn).and_return 'fake pid'
      allow(Herokubed).to receive(:database_url).and_return 'fake_db_url'
      allow(Process).to receive(:wait)
      Herokubed.transfer_db(*params.split)
    end

    context 'with two parameters' do
      let(:params) { 'one_param two_param' }

      context 'happy path' do
        it 'uses the source app_name to get the source database_url' do
          expect(Herokubed).to have_received(:database_url).with('one_param')
        end

        it 'performs a command line copy' do
          expected_command = 'heroku pg:copy fake_db_url DATABASE_URL --app two_param --confirm two_param'
          expect(Herokubed).to have_received(:spawn).with(expected_command)
        end

        it 'waits on the fake pid' do
          expect(Process).to have_received(:wait).with 'fake pid'
        end
      end

      context 'when HEROKU_TOKEN is not available in environment' do
        pending
      end

      context 'when first param is not an app' do
        pending
      end

      context 'when second param is not an app' do
        pending
      end

      context 'when either app has no database' do
        pending
      end

      context 'when either app has more than one database' do
        pending
      end
    end

    context 'with more than two parameters' do
      let(:params) { 'one_param two_param three_param' }
      it_behaves_like 'an incorrect commandline usage'
    end

    context 'with insufficient parameters' do
      let(:params) { 'one_param' }
      it_behaves_like 'an incorrect commandline usage'
    end

    context 'with no parameters' do
      let(:params) { '' }
      it_behaves_like 'an incorrect commandline usage'
    end
  end

  describe '.database_url' do
    let(:input_app_name) { 'bob_app' }
    subject { Herokubed.database_url(input_app_name) }
    before do
      allow(Net::HTTP).to receive(:GET)
    end
  end
end