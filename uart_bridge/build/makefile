VIVADO=/opt/Xilinx/Vivado/2016.2/bin/vivado
VIVADO_OPT=-mode batch -nojournal -nolog -tempDir vivtmp
PROJECT=uart_bridge
CLK_FREQ=200000000
BAUDRATE_A=9600
BAUDRATE_B=115200
PART=xc7a200tfbg676-2

HDL_SOURCES=$(wildcard ../src/hdl/*.vhd)
XDC_SOURCES=$(wildcard ../src/constr/*.xdc)

IP_SRC_PATH=../src/ip
IP_SOURCES=$(wildcard ${IP_SRC_PATH}/*.tcl)
IP_DST_PATH=ip
IP_SOURCES_NAMES=$(notdir $(basename ${IP_SOURCES}))
IP_DCPS=$(addsuffix .dcp, $(addprefix ${IP_DST_PATH}/, ${IP_SOURCES_NAMES}))



${PROJECT}.bit   : impl.dcp
	${VIVADO}  route.dcp ${VIVADO_OPT} -source tcl/bitstream.tcl -tclargs ${PROJECT}
    	
impl.dcp : synth.dcp
	${VIVADO} synth.dcp ${VIVADO_OPT} -source tcl/impl.tcl
	
synth.dcp : ${HDL_SOURCES} ${IP_DCPS} ${XDC_SOURCES}
	${VIVADO} ${VIVADO_OPT} -source tcl/synth.tcl -tclargs ${PROJECT} ${PART} ${CLK_FREQ} ${BAUDRATE_A} ${BAUDRATE_B}
	
.PHONY : synth_ip
synth_ip : ${IP_DCPS}

${IP_DST_PATH}/%.dcp : ${IP_SRC_PATH}/%.tcl
	${VIVADO} ${VIVADO_OPT} -source tcl/synth_ip.tcl -tclargs ${PART} $^
	

run: ${PROJECT}.bit
	${VIVADO} ${VIVADO_OPT} -source tcl/run.tcl -tclargs ${PART} $^

test:
	echo ${IP_DCPS}

clean :
	rm -r -f .srcs
	rm -r -f vivtmp
	rm -r -f .Xil
	rm -r -f ip
	rm *.log *.xml *.html *.jou *.str *.dcp *.bit

	
.PHONY : ip
ip:
	${VIVADO} ${VIVADO_OPT} -source tcl/create_ip.tcl -tclargs ${PART}
	
.PHONY : sim_1
sim_1 :
	${VIVADO} ${VIVADO_OPT} -source tcl/sim_1.tcl -tclargs ${PART}

.PHONY : open_synth
open_synth : synth.dcp
	${VIVADO} synth.dcp -nojournal -nolog -tempDir vivtmp
	
