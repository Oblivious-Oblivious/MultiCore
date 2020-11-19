require "./rmodules/test_scanner.rb"

def main
    QML.run do |app| # Run the qml app
        # Load the file
        app.load_path("#{Pathname.pwd}/qml/test_scanner.qml");
    end
end
main;
