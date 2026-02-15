#ifndef __AXL_MODULE_HPP
#define __AXL_MODULE_HPP

#include "axl.h"
#include "posix_module.hpp"

class axl_module_t : public posix_module_t {
    axl_xfer_t axl_type;
    bool axl_transfer_file(const std::string& source, const std::string& dest);

  public:
    axl_module_t(const std::string& scratch, const std::string& persistent,
                 const std::string& axl_type_str);
    virtual ~axl_module_t();
    virtual bool flush(const command_t& cmd);
    virtual bool restore(const command_t& cmd);
};

#endif //__AXL_MODULE_HPP
