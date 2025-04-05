type ListNode__
    prev as ListNode__ ptr
    next as ListNode__ ptr
end type

#ifndef null
#define null cast(any ptr, 0)
#endif