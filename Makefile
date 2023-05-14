PROJ = pong_game
PIN_DEF = ice40-io-video.pcf
DEVICE = hx1k
MODULES = pong.v VGA_gen.v button.v shift_register.v osd.v osd_time_base.v character_memory.v score_register.v clock_generator.v bcd_counter.v bcd_8bit_counter.v reset_gen.v

all: $(PROJ).rpt $(PROJ).bin

%.blif: %.v
	yosys -l log.txt -p 'synth_ice40 -top pong_game -blif $@' $< $(MODULES)

%.asc: $(PIN_DEF) %.blif
	arachne-pnr -d $(subst hx,,$(subst lp,,$(DEVICE))) -o $@ -p $^ -P vq100

%.bin: %.asc
	icepack $< $@

%.rpt: %.asc
	icetime -d $(DEVICE) -mtr $@ $<

prog: $(PROJ).bin
	iceprogduino $<

sudo-prog: $(PROJ).bin
	@echo 'Executing prog as root!!!'
	sudo iceprogduino $<

clean:
	rm -f $(PROJ).blif $(PROJ).asc $(PROJ).bin

.PHONY: all prog clean
