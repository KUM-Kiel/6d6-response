all:
	@mkdir -p resp
	ruby lib/response.rb

clean:
	rm -rf resp/
