NAME := nexys4DDR_7seg_test_0

all: $(NAME).bit

$(NAME).bit:  $(NAME)_run.tcl $(NAME).xpr
	vivado -mode batch -source $^

$(NAME).xpr: $(NAME).tcl
	vivado -mode batch -source $<

build-gui: $(NAME).xpr
	vivado $<