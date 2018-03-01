all:
	@mkdir -p resp
	ruby default.rb

clean:
	rm -rf resp/
