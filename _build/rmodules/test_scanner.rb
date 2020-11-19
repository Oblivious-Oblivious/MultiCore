require "qml"
require "./libs/test_scanner.so" # Library of C++ file

require_relative "ruby_scanner" # FIXX #

## QML ##
# For error handling include QML::Access for "to_qml" method
class Thread
	include QML::Access;
end

# Scanner 1.0
module Scanner
	VERSION = "1.0";
	class RubyScanner
		include QML::Access; # Enable creation of signals and slots
		register_to_qml; ### (under: "Scanner", version: "1.0"); # Scanner 1.0

		### QML Values ###
		property(:inputHost) { "0.0.0.0" }; # Value of host field
		property(:inputStartPort) { "-1" }; # Value of start port field
		property(:inputEndPort) { "-1" }; # Value of end port field
		property(:inputTimeout) { "35" } # Timeout for the scanner (in milliseconds)
		property(:inputType) { "SYN" }; # Type of scan

		### Values passed back by Ruby to QML ###
		property(:currentPort) {}; # Value of current port scanned

		### QML Signals ###
		signal(:portOpen, []); # Signal emmitted when a port is open (1)
		signal(:portFiltered, []); # Signal emmitted when a port is filtered (2)
		signal(:endOfScan, []); # Signal emmitted when the scan is over
		# If currentPort is 1 the port is closed

		### Ruby Values ###
		attr_accessor :host, :start_port, :end_port, :timeout, :type, :t;

		### Set Ruby values from grabbed QML values ###
		def __grab_values
			self.host = inputHost;
			self.start_port = inputStartPort.to_i;
			self.end_port = inputEndPort.to_i;
			self.timeout = inputTimeout;
			self.type = inputType;
			self.t = self.end_port - self.start_port;
		end
	end
end
