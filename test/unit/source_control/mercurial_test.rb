require 'test_helper'

module SourceControl
  class MercurialTest < Test::Unit::TestCase

    include FileSandbox

    def setup
      @mercurial = Mercurial.new
    end

    def test_update
      in_sandbox do
        revision = Mercurial::Revision.new('abcde')
        @mercurial.expects(:hg).with("pull")
        @mercurial.expects(:hg).with("update", ['-r', 'abcde'])
        @mercurial.update(revision)
      end
    end

    def test_latest_revision
      in_sandbox do
        parser = mock('parser')
        parser.expects(:parse).with("log_result").returns(["foo"])
        Mercurial::LogParser.expects(:new).returns(parser)

        @mercurial.expects(:hg).with("pull")
        @mercurial.expects(:hg).with("log", ['-v', '-r', 'tip']).returns("log_result")
        assert_equal("foo", @mercurial.latest_revision)
      end
    end

    def test_latest_revision_with_branch_specified
      in_sandbox do
        mercurial = Mercurial.new :branch => 'branch'
        parser = mock('parser')
        parser.expects(:parse).with("log_result").returns(["foo"])
        Mercurial::LogParser.expects(:new).returns(parser)

        mercurial.expects(:hg).with("pull")
        mercurial.expects(:hg).with("log", ['-v', '-l', '1', '-b', 'branch']).returns("log_result")
        assert_equal("foo", mercurial.latest_revision)
      end
    end

    def test_update
      in_sandbox do
        stub_revision = stub('revision', :number => '12345')
        @mercurial.expects(:hg).with('pull')
        @mercurial.expects(:update_local).with(stub_revision)
        assert_nothing_raised { @mercurial.update(stub_revision) }
      end
    end

    def test_update_with_no_revision_specified
      in_sandbox do
        @mercurial.expects(:hg).with('pull')
        @mercurial.expects(:update_local).with(nil)
        assert_nothing_raised { @mercurial.update }
      end
    end

    def test_update_local
      in_sandbox do
        stub_revision = stub('revision', :number => '12345')
        @mercurial.expects(:hg).with('update', ['-r', '12345'])
        assert_nothing_raised { @mercurial.update_local(stub_revision) }
      end
    end

    def test_update_local_with_no_revision_specified
      in_sandbox do
        @mercurial.expects(:hg).with('update')
        assert_nothing_raised { @mercurial.update_local }
      end
    end

    def test_update_local_with_branch_specified
      in_sandbox do
        mercurial = Mercurial.new :branch => 'branch'
        mercurial.expects(:hg).with('update', ['-C', 'branch'])
        assert_nothing_raised { mercurial.update_local }
      end
    end

    def test_checkout
      mercurial_with_checkout_data = Mercurial.new(:repository => '/tmp/hg_repo')
      in_sandbox do
        mercurial_with_checkout_data.expects(:hg).with(
            'clone', ['/tmp/hg_repo', '.'], :execute_in_project_directory => false)
        assert_nothing_raised { mercurial_with_checkout_data.checkout }
      end
    end

    def test_checkout_to_a_given_directory
      hg = Mercurial.new(:repository => '/tmp/hg_repo')
      in_sandbox do |sandbox|
        hg.expects(:hg).with('clone', ['/tmp/hg_repo', 'somewhere'], :execute_in_project_directory => false)
        FileUtils.mkdir File.join(sandbox.root, "somewhere")
        assert_nothing_raised { hg.checkout(nil, $stdout, "somewhere") }
      end
    end

    def test_checkout_should_switch_to_a_specified_branch
      mercurial_with_checkout_data = Mercurial.new(:repository => '/tmp/hg_repo', :branch => 'a_branch')
      in_sandbox do
        mercurial_with_checkout_data.expects(:hg).with(
            'clone', ['/tmp/hg_repo', '.'], :execute_in_project_directory => false)
        mercurial_with_checkout_data.expects(:hg).with('update', ['-C', 'a_branch'])
        assert_nothing_raised { mercurial_with_checkout_data.checkout }
      end
    end

    def test_checkout_should_accept_a_revision
      mercurial_with_checkout_data = Mercurial.new(:repository => '/tmp/hg_repo')
      in_sandbox do
        mercurial_with_checkout_data.expects(:hg).with(
            'clone', ['/tmp/hg_repo', '.'], :execute_in_project_directory => false)
        mercurial_with_checkout_data.expects(:hg).with('update', ['-r', '12345'])
        assert_nothing_raised { mercurial_with_checkout_data.checkout('12345') }
      end
    end

    def test_up_to_date_with_no_new_revisions
      @mercurial.expects(:update_local)
      @mercurial.expects(:new_revisions).returns([])
      assert(@mercurial.up_to_date?)
    end

    def test_up_to_date_with_new_revisions
      @mercurial.expects(:update_local)
      @mercurial.expects(:new_revisions).returns(['revision1'])
      revisions = ['pre']
      assert(!@mercurial.up_to_date?(revisions))
      assert(revisions == ['pre', 'revision1'])
    end

    def test_revisions_since

    end

    # TODO tests for other public methods of this class

  end
end
