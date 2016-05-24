

/**
 * Class: generic_rom_agent
 */
class generic_rom_agent `GENERIC_ROM_AGENT_PLIST extends uvm_agent;
	
	typedef generic_rom_agent `GENERIC_ROM_AGENT_PARAMS this_t;
	
	`uvm_component_param_utils(this_t)
	
	typedef generic_rom_driver `GENERIC_ROM_AGENT_PARAMS  drv_t;
	typedef generic_rom_monitor `GENERIC_ROM_AGENT_PARAMS mon_t;
	typedef generic_rom_config  `GENERIC_ROM_AGENT_PARAMS cfg_t;

	const string report_id = "generic_rom_agent";

	drv_t											m_driver;
	uvm_sequencer #(generic_rom_seq_item)			m_seqr;
	mon_t											m_monitor;
	
	uvm_analysis_port #(generic_rom_seq_item)		m_mon_out_ap;
	uvm_analysis_port #(generic_rom_seq_item)		m_drv_out_ap;
	
	cfg_t											m_cfg;
	
	
	function new(string name, uvm_component parent=null);
		super.new(name, parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	
		// Obtain the config object for this agent
		m_cfg = cfg_t::get_config(this);
		
		if (m_cfg.has_driver) begin
			m_driver = drv_t::type_id::create("m_driver", this);
			
			// Create driver analysis port
			m_drv_out_ap = new("m_drv_out_ap", this);
		end
		
		if (m_cfg.has_sequencer) begin
			m_seqr = new("m_seqr", this);
		end
	
		if (m_cfg.has_monitor) begin
			m_monitor = mon_t::type_id::create("m_monitor", this);
			
			// Create the monitor analysis port
			m_mon_out_ap = new("m_mon_out_ap", this);
		end
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		
		// Connect the driver and sequencer
		if (m_cfg.has_driver && m_cfg.has_sequencer) begin
			m_driver.seq_item_port.connect(m_seqr.seq_item_export);
		end
		
		if (m_cfg.has_monitor) begin
			// Connect the monitor to the monitor AP
			m_monitor.ap.connect(m_mon_out_ap);
		end
		
		if (m_cfg.has_driver) begin
			// Connect the driver to the driver AP
			m_driver.ap.connect(m_drv_out_ap);
		end
		
	endfunction

endclass


