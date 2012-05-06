module Oaiharvest
  module Cdwalite

    include StringSupport
    include HashSupport

    attr_accessor :excessive

    def to_attributes name_list
      name_list.uniq.collect do |n| 
        underscore(n).to_sym
      end
    end

    def classify element
      name_list = element.children.collect(&:name)
      attributes = to_attributes(name_list)
      class_name = camelize(element.name)
      named_object = Struct.new(class_name, *attributes).new
      named_object.extend(Cdwalite)
      named_object
    end

    def extract_child_objects element
      named_object = classify(element)
      unless can_be_array(element)
        element.children.collect do |child|
          child_sym = underscore(child.name).to_sym
          data = extract_child_objects( child )
          named_object.send("#{child_sym}=", data)
        end
      else
        child_sym = underscore(element.child.name).to_sym
        named_object.send("#{child_sym}=", element.children.collect(&:text))
      end
      named_object
    end

    def extract_objects prefix_element
      first_level_object = classify(prefix_element)
      prefix_element.children.each do |element|
        element_sym = underscore(element.name).to_sym
        if can_be_array(element)
          data = element.parent.children.collect(&:text)
        elsif element.child && element.child.text?
          data = element.text
        else 
          data = first_level_object.extract_objects(element)
        end
        first_level_object.send("#{element_sym}=", data) 
      end
      first_level_object
    end

    def can_be_array element
      child_names = element.parent.children.collect(&:name).uniq
      child_names.count == 1 && !is_excessive(element)
    end
  end
end
