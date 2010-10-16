require 'lib/basecamp_wrapper'

class BasecampIntegration
  
  def self.perform(*args)
    new(*args).perform
  end
  
  def initialize(options)
    # This stuff will be in the DataSource model 
    Basecamp.establish_connection!("#{options[:subdomain]}.basecamphq.com",options[:username],options[:password],true)
    Basecamp.establish_connection!(site,options[:username],options[:password],false) 
    
    begin
      projects = Basecamp::Project.all # Have them choose one somehow?
      @project_id = projects.first.id
      @user_id = Basecamp::Person.find_by_username(options[:username]).id
    rescue
      # Bad connection info if here
    end
  end
  
  def perform
    # This should check what type of data is needed, and run the appropriate
    # method(s).
    todo_list
  end
  
  def todo_list
    finished_keys = [:finished, :unfinished]
    assigned_keys = [:anyone_count, :assigned_count]
    values = []
    tasks = {}
    
    finished_keys.each do |finished_key|
      tasks[finished_key] = {}
      assigned_keys.each do |assigned_key|
        tasks[finished_key][assigned_key] = 0
      end
    end
    
    todo_lists = Basecamp::TodoList.all(@project_id, nil)
    todo_lists.each do |todo_list|
      todo_list.todo_items.each do |todo_item|
        assigned_key = todo_item.attributes["responsible_party_id"] == @user_id ? :assigned_count : :anyone_count
        finished_key = todo_item.completed? ? :finished : :unfinished
        tasks[finished_key][assigned_key] += 1
      end
    end
    
    finished_keys.each do |finished_key|
      assigned_keys.each do |assigned_key|
        values << tasks[finished_key][assigned_key]
      end
    end
    
    values
  end
end
