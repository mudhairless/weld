#include once "list-module.bi"

constructor fbe_ListNode__module ( byref x as const fbe_ListNode__module )
end constructor

'' :::::
destructor fbe_ListNode__module ( )
end destructor

'' :::::
    constructor fbe_ListIterator__module ( byval node as ListNode__ ptr )
        m_node = node
    end constructor

    '' :::::
    operator * ( byref self as const fbe_ListIterator__module ) as module ptr
        return @cast(fbe_ListNode__module ptr, self.m_node)->obj
    end operator

    '' :::::
    function fbe_ListIterator__module.Get ( ) as module ptr
        return @cast(fbe_ListNode__module ptr, m_node)->obj
    end function

    '' :::::
    sub fbe_ListIterator__module.Increment ( )
        m_node = m_node->next
    end sub

    '' :::::
    sub fbe_ListIterator__module.Decrement ( )
        m_node = m_node->prev
    end sub

    '' :::::
    function fbe_ListIterator__module.PostIncrement ( ) as fbe_ListIterator__module
        var tmp = this
        this.Increment()
        return tmp
    end function

    '' :::::
    function fbe_ListIterator__module.PostDecrement ( ) as fbe_ListIterator__module
        var tmp = this
        this.Decrement()
        return tmp
    end function

    '' :::::
    constructor fbe_ListIteratorToConst__module ( byref x as const fbe_ListIterator__module )
        m_node = x.m_node
    end constructor

    '' :::::
    constructor fbe_ListIteratorToConst__module ( byval node as const ListNode__ ptr )
        m_node = cast(ListNode__ ptr, cast(any ptr, node))
    end constructor

    '' :::::
    operator * ( byref self as const fbe_ListIteratorToConst__module ) as const module ptr
        return cast(const module ptr, self.m_node + 1)
    end operator

    '' :::::
    function fbe_ListIteratorToConst__module.Get ( ) as const module ptr
        return cast(const module ptr, m_node + 1)
    end function

    '' :::::
    sub fbe_ListIteratorToConst__module.Increment ( )
        m_node = m_node->next
    end sub

    '' :::::
    sub fbe_ListIteratorToConst__module.Decrement ( )
        m_node = m_node->prev
    end sub

    '' :::::
    function fbe_ListIteratorToConst__module.PostIncrement ( ) as fbe_ListIteratorToConst__module
        var tmp = this
        this.Increment()
        return tmp
    end function

    '' :::::
    function fbe_ListIteratorToConst__module.PostDecrement ( ) as fbe_ListIteratorToConst__module
        var tmp = this
        this.Decrement()
        return tmp
    end function

    '' :::::
    operator = ( byref x as fbe_ListIterator__module, byref y as fbe_ListIterator__module ) as boolean
        return x.m_node = y.m_node
    end operator

    '' :::::
    operator = ( byref x as fbe_ListIteratorToConst__module, byref y as fbe_ListIteratorToConst__module ) as boolean
        return x.m_node = y.m_node
    end operator

    '' :::::
    operator <> ( byref x as fbe_ListIterator__module, byref y as fbe_ListIterator__module ) as boolean
        return x.m_node <> y.m_node
    end operator

    '' :::::
    operator <> ( byref x as fbe_ListIteratorToConst__module, byref y as fbe_ListIteratorToConst__module ) as boolean
        return x.m_node <> y.m_node
    end operator

    constructor fbe_Allocator_module ( )
        ' nothing to be done here.
    end constructor
    
    '' :::::
    constructor fbe_Allocator_module ( byref x as const fbe_Allocator_module )
        ' nothing to be done here.
    end constructor
    
    '' :::::
    destructor fbe_Allocator_module ( )
        ' nothing to be done here.
    end destructor
    
    '' :::::
    function fbe_Allocator_module.Allocate ( byval n as uinteger, byval hint as module ptr ) as module ptr
        return cast(module ptr, new byte[n * sizeof(module)])
    end function
    
    '' :::::
    sub fbe_Allocator_module.DeAllocate ( byval p as module ptr, byval n as uinteger )
        delete[] cast(byte ptr, p)
    end sub
    
    '' :::::
    sub fbe_Allocator_module.Construct ( byval p as module ptr, byref value as const module )
    
        var tmp = new(p) module(value)
    
    end sub
    
    '' :::::
    sub fbe_Allocator_module.Destroy ( byval p as module ptr )
    
        p->destructor()
    
    end sub

    constructor fbe_Allocator_fbe_ListNode__module ( )
        ' nothing to be done here.
    end constructor
    
    '' :::::
    constructor fbe_Allocator_fbe_ListNode__module ( byref x as const fbe_Allocator_fbe_ListNode__module )
        ' nothing to be done here.
    end constructor
    
    '' :::::
    destructor fbe_Allocator_fbe_ListNode__module ( )
        ' nothing to be done here.
    end destructor
    
    '' :::::
    function fbe_Allocator_fbe_ListNode__module.Allocate ( byval n as uinteger, byval hint as fbe_ListNode__module ptr ) as fbe_ListNode__module ptr
        return cast(fbe_ListNode__module ptr, new byte[n * sizeof(fbe_ListNode__module)])
    end function
    
    '' :::::
    sub fbe_Allocator_fbe_ListNode__module.DeAllocate ( byval p as fbe_ListNode__module ptr, byval n as uinteger )
        delete[] cast(byte ptr, p)
    end sub
    
    '' :::::
    sub fbe_Allocator_fbe_ListNode__module.Construct ( byval p as fbe_ListNode__module ptr, byref value as const fbe_ListNode__module )
    
        var tmp = new(p) fbe_ListNode__module(value)
    
    end sub
    
    '' :::::
    sub fbe_Allocator_fbe_ListNode__module.Destroy ( byval p as fbe_ListNode__module ptr )
    
        p->destructor()
    
    end sub

    '' :::::
    function fbe_List_module.m_CreateNode ( ) as ListNode__ ptr

        var newnode = m_alloc.Allocate(1)
        dim value as module
        dim talloc as typeof(T_Allocator)
        talloc.Construct(@newnode->obj, value)
        return cast(ListNode__ ptr, newnode)

    end function

    '' :::::
    function fbe_List_module.m_CreateNode ( byref value as const module ) as ListNode__ ptr

        var newnode = m_alloc.Allocate(1)
        dim talloc as typeof(T_Allocator)
        talloc.Construct(@newnode->obj, value)
        return cast(ListNode__ ptr, newnode)

    end function

    '' :::::
    constructor fbe_List_module ( )
        m_node.prev = @m_node
        m_node.next = @m_node
    end constructor

    '' :::::
    constructor fbe_List_module ( byref x as const fbe_List_module )

        m_node.prev = @m_node
        m_node.next = @m_node
        this.Assign(x.cBegin(), x.cEnd())

    end constructor

    '' :::::
    constructor fbe_List_module ( byval first as typeof(IteratorToConst), byval last as typeof(IteratorToConst) )

        m_node.prev = @m_node
        m_node.next = @m_node
        this.Assign(first, last)

    end constructor

    '' :::::
    constructor fbe_List_module ( byval n as uinteger )

        for t as uinteger = 0 to n
            dim tmp as module
            this.PushBack(tmp)
        next t

    end constructor

    '' :::::
    constructor fbe_List_module ( byval n as uinteger, byref valu as const module )

        for t as uinteger = 0 to n
            this.PushBack(valu)
        next t

    end constructor

    '' :::::
    destructor fbe_List_module ( )
        this.Clear()
    end destructor

    '' :::::
    operator fbe_List_module.let ( byref x as const fbe_List_module )

        dim first as typeof(IteratorToConst) = x.m_node.next
        dim last as typeof(IteratorToConst) = @x.m_node
        this.Assign(first, last)

    end operator

    '' :::::
    sub fbe_List_module.Assign ( byval first as typeof(IteratorToConst), byval last as typeof(IteratorToConst) )

        dim first1 as typeof(Iterator) = m_node.next
        dim last1 as typeof(Iterator) = @m_node
        var first2 = first
        var last2 = last

        ' re-assign any existing elements.
        do while (first1 <> last1) andalso (first2 <> last2)
            **(first1.PostIncrement()) = **(first2.PostIncrement())
        loop

        ' not enough existing elements ?
        if first2 <> last2 then
            this.Insert(last1, first2, last2)

        else
            var tmp = this.Erase(first1, last1)

        end if

    end sub

    '' :::::
    sub fbe_List_module.Assign ( byval n as uinteger, byref value as const module )

        dim first as typeof(Iterator) = m_node.next
        dim last as typeof(Iterator) = @m_node

        ' re-assign any existing elements.
        do while (first <> last) andalso n > 0
            **(first.PostIncrement()) = value
            n -= 1
        loop

        ' not enough existing elements ?
        if n > 0 then
            this.Insert(first, n, value)

        else
            var tmp = this.Erase(first, last)

        end if

    end sub

    '' :::::
    function fbe_List_module.Size ( ) as uinteger

        dim first as typeof(IteratorToConst) = m_node.next
        dim last as typeof(IteratorToConst) = @m_node
        dim c as uinteger = 0

        do while first <> last
            c += 1
            first.Increment()
        loop
        return c

    end function

    '' :::::
    sub fbe_List_module.Resize ( byval x as uinteger )

        dim tmp as module
        this.Resize( x, tmp )

    end sub

    '' :::::
    sub fbe_List_module.Resize ( byval x as uinteger, byref v as const module )

        var s = this.Size()

        if x = s then return

        if x < s then

            var diff = s - x
            var it = this.End_()

            for n as uinteger = 1 to diff
                it.Decrement()
            next

            var unused = this.Erase(it,this.End_())

        else

            var diff = x - s

            for n as uinteger = 1 to diff
                this.PushBack(v)
            next

        end if

    end sub

    '' :::::
    function fbe_List_module.Empty ( ) as boolean
        return m_node.next = @m_node
    end function

    '' :::::
    function fbe_List_module.Begin ( ) as typeof(Iterator)
        return m_node.next
    end function

    '' :::::
    function fbe_List_module.cBegin ( ) as typeof(IteratorToConst)
        return m_node.next
    end function

    '' :::::
    function fbe_List_module.End_ ( ) as typeof(Iterator)
        return @m_node
    end function

    '' :::::
    function fbe_List_module.cEnd ( ) as typeof(IteratorToConst)
        return @m_node
    end function

    '' :::::
    function fbe_List_module.Front ( ) as module ptr
        return @cast(fbe_ListNode__module ptr, m_node.next)->obj
    end function

    '' :::::
    function fbe_List_module.cFront ( ) as const module ptr
        return @cast(const fbe_ListNode__module ptr, m_node.next)->obj
    end function

    '' :::::
    function fbe_List_module.Back ( ) as module ptr
        return @cast(fbe_ListNode__module ptr, m_node.prev)->obj
    end function

    '' :::::
    function fbe_List_module.cBack ( ) as const module ptr
        return @cast(const fbe_ListNode__module ptr, m_node.prev)->obj
    end function

    '' :::::
    sub fbe_List_module.PushFront ( byref x as const module )
        var tmp = this.Insert(m_node.next, x)
    end sub

    '' :::::
    sub fbe_List_module.PushBack ( byref x as const module )
        var tmp = this.Insert(@m_node, x)
    end sub

    '' :::::
    sub fbe_List_module.PopFront ( )
        var tmp = this.Erase(m_node.next)
    end sub

    '' :::::
    sub fbe_List_module.PopBack ( )
        var tmp = this.Erase(m_node.prev)
    end sub

    '' :::::
    function fbe_List_module.Insert ( byval position as typeof(Iterator), byref x as const module ) as typeof(Iterator)

        var newnode = m_CreateNode(x)

        newnode->prev = position.m_node->prev
        newnode->next = position.m_node
        newnode->prev->next = newnode
        newnode->next->prev = newnode

        ' auto-converts from a node to an iterator..
        return newnode

    end function

    '' :::::
    sub fbe_List_module.Insert ( byval position as typeof(Iterator), byval n as uinteger, byref x as const module )

        for n = n to 1 step - 1
            position = this.Insert(position, x)
        next

    end sub

    '' :::::
    sub fbe_List_module.Insert ( byval position as typeof(Iterator), byval first as typeof(IteratorToConst), byval last as typeof(IteratorToConst) )

        do while first <> last
            var tmp = this.Insert(position, **first)
            first.Increment()
        loop

    end sub

    '' :::::
    sub fbe_List_module.Splice ( byval position as typeof(Iterator), byref lst as fbe_List_module )

        this.Splice(position,lst,lst.Begin(),lst.End_())

    end sub

    '' :::::
    sub fbe_List_module.Splice ( byval position as typeof(Iterator), byref lst as fbe_List_module, byval frst as typeof(Iterator) )

        this.Splice(position,lst,frst,lst.End_())

    end sub

    '' :::::
    sub fbe_List_module.Splice ( byval position as typeof(Iterator), byref lst as fbe_List_module, byval frst as typeof(Iterator), byval lastp as typeof(Iterator) )

        var this_iter = position
        var first = frst
        var last = lastp

        do while first <> last
            var tmp = this.Insert(this_iter,*first.get())
            this_iter = tmp
            this_iter.Increment()
            first.Increment()
        loop

        var unused = lst.Erase(frst,lastp)

    end sub


    '' :::::
    function fbe_List_module.Erase ( byval position as typeof(Iterator) ) as typeof(Iterator)

        var nextnode = position.m_node->next

        ' remove from node chain..
        position.m_node->prev->next = nextnode
        nextnode->prev = position.m_node->prev

        ' destroy object and free node memory..
        var node = cast(fbe_ListNode__module ptr, position.m_node)
        var talloc = fbe_Allocator_module
        talloc.Destroy(@node->obj)
        m_alloc.DeAllocate(node, 1)

        ' auto-converts from a node to an iterator..
        return nextnode

    end function

    '' :::::
    function fbe_List_module.Erase ( byval first as typeof(Iterator), byval last as typeof(Iterator) ) as typeof(Iterator)

        do while first <> last
            first = this.Erase(first)
        loop
        return first

    end function

    '' :::::
    sub fbe_List_module.Clear ( )
        var tmp = this.Erase(m_node.next, @m_node)
    end sub

    '' :::::
    sub fbe_List_module.RemoveIf ( byval pred as function ( byref as const module ) as boolean )

        dim first as typeof(Iterator) = m_node.next
        dim last as typeof(Iterator) = @m_node

        do while first <> last
            var nextnode = first : nextnode.Increment()
            if pred(**first) then
                var tmp = this.Erase(first)
            end if
            first = nextnode
        loop

    end sub