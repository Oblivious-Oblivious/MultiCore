class Object
	## Custom attr_accessor
	def nattr_accessor(*fields, &bl)
		fields.each do |field|
			## Getter ##
			define_method(field) do
				instance_variable_get("@#{field}");
			end

			## Setter ##
			define_method("#{field}=") do |wut|
				instance_variable_set("@#{field}", wut);
			end

			## Initialize ##
			define_method(:initialize) do |hush = {}|
				hush.each do |key, value|
					instance_variable_set("@#{key}", value) if fields.include?(key);
				end
				yield if block_given?;
			end
		end
	end

	## Object 'not' operator ##
	def not
		Not.new(self);
	end

	class Not
		## Not allowed
		# methods starting with underscore (__send__)
		# methods which are not words (!=)
		# methods which end in "binding"
		private *instance_methods.select { |m| m !~ /(^__|^\W|^binding$)/ };

		def initialize(original)
			@original = original;
		end

		# TODO #
		## nattr_accessor :original
		# TODO #

		def method_missing(com, *args, &bl)
			!@original.send(com, *args, &bl); # Negates true to false and false to true
		end
	end

	## Minimal Debugger ##
	def dbg(o)
		puts "Inspecting object operation: #{o.inspect}";
		o; # Returns object
	end
end

class Array
	def foldl(method) # Perform the given method to the array passed
		inject { |result, i| result ? result.send(method, i): i };
	end

	def relay(data_type) # Convert to given data type
		self.map { |s| s.send("to_#{data_type}") };
	end
end

class String
	def words # Split the string into an array of its words
		split(' ');
	end

	COLORS = {
        black:   "000",
		red:     "f00",
		green:   "0f0",
		yellow:  "ff0",
		blue:    "00f",
		magenta: "f0f",
		cyan:    "0ff",
		white:   "fff"
	}
	COLORS.each do |color,code|
		define_method "to_#{color}" do
			"<span style=\"color: ##{code}\">#{self}</span>"
		end
	end
end
