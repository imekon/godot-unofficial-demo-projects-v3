#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <gdnative_api_struct.gen.h>

#include "clipper.hpp"

using namespace ClipperLib;

const godot_gdnative_core_api_struct *api = NULL;
const godot_gdnative_ext_nativescript_api_struct *nativescript_api = NULL;

void *clipper_constructor(godot_object *p_instance, void *p_method_data);
void clipper_destructor(godot_object *p_instance, void *p_method_data, void *p_user_data);
godot_variant clipper_add_path(godot_object *p_instance, void *p_method_data,
    void *p_user_data, int p_num_args, godot_variant **p_args);
    
void GDN_EXPORT godot_gdnative_init(godot_gdnative_init_options *p_options) 
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
    
void GDN_EXPORT godot_nativescript_init(void *p_handle) 
{
    godot_instance_create_func create = { NULL, NULL, NULL };
    create.create_func = &clipper_constructor;

    godot_instance_destroy_func destroy = { NULL, NULL, NULL };
    destroy.destroy_func = &clipper_destructor;

    nativescript_api->godot_nativescript_register_class(p_handle, "CLIPPER", "Reference",
        create, destroy);

    godot_instance_method add_path = { NULL, NULL, NULL };
    add_path.method = &clipper_add_path;

    godot_method_attributes attributes = { GODOT_METHOD_RPC_MODE_DISABLED };

    nativescript_api->godot_nativescript_register_method(p_handle, "CLIPPER", "add_path",
        attributes, add_path);
}

typedef struct user_data_struct 
{
    Clipper *clipper;
} user_data_struct;

void *clipper_constructor(godot_object *p_instance, void *p_method_data) 
{
    user_data_struct *user_data = (user_data_struct *)api->godot_alloc(sizeof(user_data_struct));
    user_data->clipper = new Clipper();

    return user_data;
}

void clipper_destructor(godot_object *p_instance, void *p_method_data, void *p_user_data)
{
    delete ((user_data_struct *)p_user_data)->clipper;
    api->godot_free(p_user_data);
}

godot_variant clipper_add_path(godot_object *p_instance, void *p_method_data,
        void *p_user_data, int p_num_args, godot_variant **p_args) 
{
    godot_variant ret;

    return ret;
}

