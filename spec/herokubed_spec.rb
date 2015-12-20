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
      allow(Process).to receive(:wait)
      Herokubed.ktransferdb(*params.split)
    end

    #heroku pg:copy flailing-papaya-42::ORANGE GREEN --app sushi

    context 'with two parameters' do
      let(:params) { 'one_param two_param' }

      context 'happy path' do
        it 'performs a command line copy' do
          expected_command = 'heroku pg:copy one_param --app two_param'
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
end