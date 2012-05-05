module Oaiharvest
  module Cdwalite

    include StringSupport

    attr_accessor :excessive

    def to_attributes name_list
      attributes = name_list.collect do |n| 
        underscore(deWrap(n))
      end
      attributes.collect(&:to_sym).uniq
    end

    def classify element
      name_list = element.children.collect(&:name)
      attributes = to_attributes(name_list)
      class_name = camelize(underscore(deWrap(element.name)))
      named_object = Struct.new(class_name, *attributes).new
      named_object.extend(Cdwalite)
      named_object
    end

    def extract_child_objects element
      element.children.collect do |child|
        element_sym = underscore(deWrap(element.name)).to_sym
        named_object = classify(element)
        if is_excessive(element)
          data = extract_child_objects child
        else
          # data = child.children.collect(&:text)
          data = child.text #record_id
        end
        debugger

        data
      end
    end

    def extract_objects prefix_element
      prefix_element.children.collect do |element|
        element_sym = underscore(deWrap(element.name)).to_sym
        named_object = classify(element)
        if can_be_array(element)
          data = element.children.collect(&:text)
        else
          data = extract_child_objects(element)
        end
        self.send("#{element_sym}=", data) 
      end
    end

    def can_be_array element
      element.children.collect(&:name).uniq.count == 1
    end
  end
end
