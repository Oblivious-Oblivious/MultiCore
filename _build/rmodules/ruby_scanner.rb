## C++ ## # TODO AUTOMATE IN FILE LIKE QML #
class TestScanner
    def initialize
    end

    def scan(host, start_port, timeout, type)
        Test_scanner.scan(host, start_port.to_s, timeout, type);
    end
end

## Ruby ##

## TODO: Find a way to insert code with metaprogramming inside modules and classes ##
module Scanner
    class RubyScanner
        ###
        #   @func: run
        #   @desc: Function that executes the scanner
        ###

        ### TODO --> Add multiple hosts <-- TODO ###
        ### TODO --> "Are you sure?" message boxes <-- TODO ###
        ### TODO --> Create default timeout options for detection prevention <-- TODO ###

        ### HARD TODO TODO --> Use metaprogramming for initalizing QML values HARD TODO TODO <-- ###
        def run
            # Grab Ruby values converted from QML
            __grab_values;
        
            # Using a virtual thread inside allows for communication
            # between the GUI and ruby during the execution of the scan

            # Every mutable object is called by 'self.'
            @thread = Thread.new do
                # Create the scan object
                ts = TestScanner.new;
                # QML.next_tick do
                    t.times do
                        ret = ts.scan(host, start_port, timeout, type);
                        if(ret == 1) # Open
                            self.currentPort = start_port; # MUTABLE OBJECT #
                            portOpen.emit;
                            # puts "ret value: #{ret}, port: #{start_port}";
                            # sleep(0.005); # Delay for QML to update the GUI # SOMEHOW FIXED ITSELF WTF
                        elsif(ret == 2) # Filtered
                            self.currentPort = start_port; # MUTABLE OBJECT #
                            portFiltered.emit;
                            # puts "ret value: #{ret}, port: #{start_port}";
                            # sleep(0.005); # Delay for QML to update the GUI
                        end
                        self.start_port += 1; # MUTABLE OBJECT #
                    end
                # end
                endOfScan.emit;
                # puts "End of scan";
                # puts;
            end
        end

        ###
        #   @func: kill_thread
        #   @desc: Kills the existing scan thread
        ###
        def kill_thread
            @thread.kill if @thread;
        end

        ###
        #   @func: quit
        #   @desc: Quits the QML application affectively terminating the whole program
        ###
        def quit
            # When quit button pressed
            QML.application.quit;
        end
    end
end