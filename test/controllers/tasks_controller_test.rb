require "test_helper"

describe TasksController do
  let (:task) {
    Task.create name: "sample task", description: "this is an example for a test",
                completion_date: Time.now + 5.days
  }

  # Tests for Wave 1
  describe "index" do
    it "can get the index path" do
      # Act
      get tasks_path

      # Assert
      must_respond_with :success
    end

    it "can get the root path" do
      # Act
      get root_path

      # Assert
      must_respond_with :success
    end
  end

  # Unskip these tests for Wave 2
  describe "show" do
    it "can get a valid task" do
      # Act
      get task_path(task.id)

      # Assert
      must_respond_with :success
    end

    it "will redirect for an invalid task" do
      # Act
      get task_path(-1)

      # Assert
      must_respond_with :redirect
    end
  end

  describe "new" do
    it "can get the new task page" do

      # Act
      get new_task_path

      # Assert
      must_respond_with :success
    end
  end

  describe "create" do
    it "can create a new task" do

      # Arrange
      task_hash = {
        task: {
          name: "new task",
          description: "new task description",
          completion_date: nil,
        },
      }

      # Act-Assert
      expect {
        post tasks_path, params: task_hash
      }.must_change "Task.count", 1

      new_task = Task.find_by(name: task_hash[:task][:name])
      expect(new_task.description).must_equal task_hash[:task][:description]
      assert_nil(new_task.completion_date)

      must_respond_with :redirect
      must_redirect_to task_path(new_task.id)
    end
  end

  # Unskip and complete these tests for Wave 3
  describe "edit" do
    it "can get the edit page for an existing task" do
      # Your code here
      get edit_task_path(task.id)

      must_respond_with :success
    end

    it "will respond with redirect when attempting to edit a non-existent task" do
      # Your code here
      get edit_task_path(-1)

      must_respond_with :redirect
      must_redirect_to tasks_path
    end
  end

  # Uncomment and complete these tests for Wave 3
  describe "update" do
    # Note:  If there was a way to fail to save the changes to a task, that would be a great
    #        thing to test.
    before do
      @updated_task = {
        task: {
          name: "Updated Task!", description: "I'm an updated task",
        },
      }
    end
    it "can update an existing task" do
      # Your code here

      task_id = task.id
      patch task_path(task_id), params: @updated_task

      edited_task = Task.find_by(id: task_id)
      expect(edited_task.name).must_equal @updated_task[:task][:name]
      expect(edited_task.description).must_equal @updated_task[:task][:description]
    end

    it "will redirect to the list of tasks if given an invalid ID" do
      # Your code here
      task_id = -1
      patch task_path(task_id), params: @updated_task

      must_respond_with :redirect
      must_redirect_to tasks_path
    end
  end

  # Complete these tests for Wave 4
  describe "destroy" do
    # Your tests go here
    before do
      @task_to_be_deleted = Task.create!(name: "new task", description: "a task to be deleted")
    end
    it "can delete an existing task" do
      expect {
        delete task_path(@task_to_be_deleted.id)
      }.must_change "Task.count", 1

      must_respond_with :redirect
      must_redirect_to tasks_path
    end

    it "must respond with 'not found' if given an invalid ID" do
      task_id = 23152

      delete task_path(task_id)

      must_respond_with :not_found
    end
  end

  # Complete for Wave 4
  describe "toggle_complete" do
    # Your tests go here
    it "marks the task as complete" do
      task = Task.new(name: "A Task", description: "A task to be completed")
      task.save

      patch complete_task_path(task.id)

      must_respond_with :redirect

      task.reload
      expect(task.completion_date).wont_be_nil
    end

    it "will redirect the user to the list of tasks for a non-existent task" do
      task_id = 59485

      patch complete_task_path(task_id)

      must_respond_with :redirect
      must_redirect_to tasks_path
    end
  end

  describe "toggle_incomplete" do
    it "marks the task as incomplete" do
      task = Task.new(name: "New task", description: "A task to be marked incomplete")
      task.save

      patch incomplete_task_path(task.id)

      must_respond_with :redirect

      task.reload
      assert_nil(task.completion_date)
    end

    it "will redirect the user to the list of tasks for a non-existent task" do
      task_id = 12324

      patch incomplete_task_path(task_id)

      must_respond_with :redirect
      must_redirect_to tasks_path
    end
  end
end
