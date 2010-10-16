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
    finished_by_others_count = 0;
    finished_by_you_count = 0;
    unfinished_assigned_to_any_count = 0;
    unfinished_assigned_to_you_count = 0;
    
    todo_lists = Basecamp::TodoList.all(@project_id, nil)
    todo_lists.each do |todo_list|
      todo_list.todo_items.each do |todo_item|
        if todo_item.attributes["responsible_party_id"] == @user_id 
          todo_item.completed ? finished_by_you_count += 1 : unfinished_assigned_to_you_count += 1
        else
          todo_item.completed? ? finished_by_others_count += 1 : unfinished_assigned_to_any_count += 1
        end
      end
    end
    
    [finished_by_others_count, finished_by_you_count, unfinished_assigned_to_any_count, unfinished_assigned_to_you_count]
  end
end
