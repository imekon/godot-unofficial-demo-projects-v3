#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sstream>
#include <gdnative_api_struct.gen.h>

#include "clipper.hpp"

using namespace std;
using namespace ClipperLib;

const godot_gdnative_core_api_struct *api = nullptr;
const godot_gdnative_ext_nativescript_api_struct *nativescript_api = nullptr;

void *clipper_constructor(godot_object *p_instance, void *p_method_data);
void clipper_destructor(godot_object *p_instance, void *p_method_data, void *p_user_data);

godot_variant clipper_add_path(godot_object *p_instance, void *p_method_data,
    void *p_user_data, int p_num_args, godot_variant **p_args);
godot_variant clipper_execute(godot_object *p_instance, void *p_method_data,
    void *p_user_data, int p_num_args, godot_variant **p_args);
    
extern "C" void GDN_EXPORT godot_gdnative_init(godot_gdnative_init_options *p_options) 
{
    api = p_options->api_struct;

    // now find our extensions
    for (int i = 0; i < api->num_extensions; i++) 
    {
        switch (api->extensions[i]->type) 
        {
            case GDNATIVE_EXT_NATIVESCRIPT: 
                nativescript_api = (godot_gdnative_ext_nativescript_api_struct *)api->extensions[i];
                break;
                
            default:
                break;
        }
    }
}
    
extern "C" void GDN_EXPORT godot_nativescript_init(void *p_handle) 
{
    godot_instance_create_func create = { nullptr, nullptr, nullptr };
    create.create_func = &clipper_constructor;

    godot_instance_destroy_func destroy = { nullptr, nullptr, nullptr };
    destroy.destroy_func = &clipper_destructor;

    nativescript_api->godot_nativescript_register_class(p_handle, "CLIPPER", "Reference",
        create, destroy);

    godot_instance_method add_path = { nullptr, nullptr, nullptr };
    add_path.method = &clipper_add_path;
    
    godot_instance_method execute = { nullptr, nullptr, nullptr };
    execute.method = &clipper_execute;

    godot_method_attributes attributes = { GODOT_METHOD_RPC_MODE_DISABLED };

    nativescript_api->godot_nativescript_register_method(p_handle, "CLIPPER", "add_path",
        attributes, add_path);
        
    nativescript_api->godot_nativescript_register_method(p_handle, "CLIPPER", "execute",
        attributes, execute);
}

extern "C" void godot_gdnative_terminate(void *p_options)
{
    api = nullptr;
    nativescript_api = nullptr;
}

typedef struct user_data_struct 
{
    Clipper *clipper;
    char marker[4];
} user_data_struct;

void *clipper_constructor(godot_object *p_instance, void *p_method_data) 
{
    ostringstream os;
    os << "clipper constructor: " << endl;
    godot_print_warning(os.str().c_str(), "clipper constructor", __FILE__, __LINE__);

    user_data_struct *user_data = (user_data_struct *)api->godot_alloc(sizeof(user_data_struct));
    user_data->clipper = new Clipper();
    strncpy(user_data->marker, "MARK", 4);
    return user_data;
}

void clipper_destructor(godot_object *p_instance, void *p_method_data, void *p_user_data)
{
    ostringstream os;
    os << "clipper destructor: " << endl;
    godot_print_warning(os.str().c_str(), "clipper destructor", __FILE__, __LINE__);

    delete ((user_data_struct *)p_user_data)->clipper;
    api->godot_free(p_user_data);
}

godot_variant clipper_add_path(godot_object *p_instance, void *p_method_data,
        void *p_user_data, int p_num_args, godot_variant **p_args) 
{
    godot_variant ret;

    ostringstream os;
    os << "clipper_add_path: " << p_num_args << endl;
    godot_print_warning(os.str().c_str(), "clipper add path", __FILE__, __LINE__);

    return ret;
}

godot_variant clipper_execute(godot_object *p_instance, void *p_method_data,
        void *p_user_data, int p_num_args, godot_variant **p_args) 
{
    godot_variant ret;

    ostringstream os;
    os << "clipper_execute: " << p_num_args << endl;
    godot_print_warning(os.str().c_str(), "clipper execute", __FILE__, __LINE__);

    return ret;
}

