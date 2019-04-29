#include "depthos/paging.h"
#include <depthos/console.h>

static int _pg_enable = 0;


void* virt_to_phys(pg_dir_t *dir,void *v_addr) {
	if (!_pg_enable) {
		return (void*)(v_addr - LOAD_MEMORY_ADDRESS);
	}	
	
	if(!dir->tabs[PG_TABLE_INDEX(v_addr)]) {
		print_mod("virt mem: page table does not exist",MOD_ERR);
		return NULL;
	}
	pg_table_t *tab = dir->tabs[PG_TABLE_INDEX(v_addr)];
	if (!tab->pages[PG_PAGE_INDEX(v_addr)].pres) {
		print_mod("virt mem: page is not present",MOD_ERR);
		return NULL;
	}
	
	uint32_t t = table->pages[PG_PAGE_INDEX(v_addr)].frame;
	t = (t << 12) + PG_PAGE_OFFSET;
	return (void*)t;
}
	
