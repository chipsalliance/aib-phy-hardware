# Makefile to run all sim tests

sims = $(wildcard ./sim*)
all:	test

test:
	@rm -f results.log
	@for dir in `find $(sims) -name Makefile -exec dirname {} \;`; do \
	echo "--> running sim in $$dir" | tee -a results.log; \
	  $(MAKE) -C $$dir | tee -a results.log; \
	done
	egrep "running sim in|TEST PASS" results.log
clean:
	@for dir in `find $(sims) -name Makefile -exec dirname {} \;` ; do \
	echo "cleaning in $$dir"; \
	$(MAKE) clean -C $$dir; \
	done

