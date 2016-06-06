find_path(GLX_INCLUDE_DIR GL/glx.h
	/usr/include
)

find_library(GLX_LIBRARIES
	NAMES GLX
	PATHS /usr/lib /usr/local/lib
)

set(GLX_FOUND "NO")
if(GLX_LIBRARIES)
	set(GLX_FOUND "YES")
endif(GLX_LIBRARIES)
