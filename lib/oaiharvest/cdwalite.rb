module Oaiharvest
  module Cdwalite

    include StringSupport
    include HashSupport

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
      named_object = classify(element)
      element.children.collect do |child|
        child_sym = underscore(deWrap(child.name)).to_sym
        if child.children.count > 1
          data = extract_child_objects( child )
          named_object.send("#{child_sym}=", data)
          return data
        else
          data = child.children.collect(&:text)
          data = child.text if data.empty? && !child.text.empty?
          # named_object.send("#{child_sym}=", data)
          accumulate(named_object, child_sym, data)
          return  data
        end
      end
    end

    def extract_objects prefix_element
      named_object = classify(prefix_element)
      prefix_element.children.each do |element|
        element_sym = underscore(deWrap(element.name)).to_sym
        data = extract_child_objects(element)
        named_object.send("#{element_sym}=", data) 
      end
      named_object
    end

    def can_be_array element
      child_names = element.children.collect(&:name).uniq
      child_names.count == 1 && !is_excessive(element.child)
    end
  end
end
