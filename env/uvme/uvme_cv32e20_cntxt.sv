// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
// Copyright 2020,2022 OpenHW Group
// Copyright 2020 Datum Technology Corporation
// Copyright 2020 Silicon Labs, Inc.
//
// Licensed under the Solderpad Hardware Licence, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     https://solderpad.org/licenses/
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.


`ifndef __UVME_CV32E20_CNTXT_SV__
`define __UVME_CV32E20_CNTXT_SV__


/**
 * Object encapsulating all state variables for CV32E20 environment
 * (uvme_cv32e20_env_c) components.
 */
class uvme_cv32e20_cntxt_c extends uvm_object;

   virtual uvmt_cv32e20_isa_covg_if          isa_covg_vif ; ///< Virtual interface for ISA coverage
   virtual uvmt_cv32e20_vp_status_if         vp_status_vif; ///< Virtual interface for Virtual Peripherals
   virtual uvma_interrupt_if                 intr_vif     ; ///< Virtual interface for interrupts
   virtual uvma_debug_if                     debug_vif    ; ///< Virtual interface for debug

   // TODO: the "debug_cov_if" is a core-specific interface
   virtual uvmt_cv32e20_debug_cov_assert_if  debug_cov_vif; ///< Virtual interface for Debug coverage

   // Hack to support backdoor updating of memory for vitual peripherals until we properly port RVFI/RVVI
//   virtual RVVI_memory                        rvvi_memory_vif;

   // Agent context handles
   uvma_clknrst_cntxt_c    clknrst_cntxt;
   uvma_interrupt_cntxt_c  interrupt_cntxt;
   uvma_debug_cntxt_c      debug_cntxt;
   uvma_obi_memory_cntxt_c obi_memory_instr_cntxt;
   uvma_obi_memory_cntxt_c obi_memory_data_cntxt;
   uvma_rvfi_cntxt_c#(ILEN,XLEN)     rvfi_cntxt;

   // Memory modelling
   rand uvml_mem_c                   mem;

   // Events
   uvm_event  sample_cfg_e;
   uvm_event  sample_cntxt_e;


   `uvm_object_utils_begin(uvme_cv32e20_cntxt_c)
      `uvm_field_object(clknrst_cntxt         , UVM_DEFAULT)
      `uvm_field_object(interrupt_cntxt       , UVM_DEFAULT)
      `uvm_field_object(debug_cntxt           , UVM_DEFAULT)
      `uvm_field_object(obi_memory_instr_cntxt, UVM_DEFAULT)
      `uvm_field_object(obi_memory_data_cntxt , UVM_DEFAULT)
      `uvm_field_object(mem                   , UVM_DEFAULT)

      `uvm_field_event(sample_cfg_e  , UVM_DEFAULT)
      `uvm_field_event(sample_cntxt_e, UVM_DEFAULT)
   `uvm_object_utils_end


   /**
    * Builds events and sub-context objects.
    */
   extern function new(string name="uvme_cv32e20_cntxt");

endclass : uvme_cv32e20_cntxt_c


function uvme_cv32e20_cntxt_c::new(string name="uvme_cv32e20_cntxt");

   super.new(name);

   clknrst_cntxt          = uvma_clknrst_cntxt_c   ::type_id::create("clknrst_cntxt"         );
   interrupt_cntxt        = uvma_interrupt_cntxt_c ::type_id::create("interrupt_cntxt"       );
   debug_cntxt            = uvma_debug_cntxt_c     ::type_id::create("debug_cntxt"           );
   obi_memory_instr_cntxt = uvma_obi_memory_cntxt_c::type_id::create("obi_memory_instr_cntxt");
   obi_memory_data_cntxt  = uvma_obi_memory_cntxt_c::type_id::create("obi_memory_data_cntxt" );
   mem = uvml_mem_c#(32)::type_id::create("mem");

   sample_cfg_e   = new("sample_cfg_e"  );
   sample_cntxt_e = new("sample_cntxt_e");

endfunction : new


`endif // __UVME_CV32E20_CNTXT_SV__
