#ifndef __inc__list_compiler__bi__
#define __inc__list_compiler__bi__ 1

#include once "compiler.bi"
#include once "list.bi"

type fbe_ListNode__compiler
        rep as ListNode__
        obj as compiler

        declare constructor ( byref as const fbe_ListNode__compiler )
        declare destructor ( )
end type

type fbe_ListIterator__compiler
public:
    '' Sub: default constructor
    '' Constructs an iterator.
    ''
    '' Parameters:
    '' node - the List node to point to, used internally by List
    declare constructor ( byval node as ListNode__ ptr = null )

    '' Function: Get
    '' Returns a reference to the list element being pointed to.
    declare function Get ( ) as compiler ptr

    '' Sub: Increment
    '' Moves the iterator forward in the list.
    declare sub Increment ( )

    '' Sub: Decrement
    '' Moves the iterator backward in the list.
    declare sub Decrement ( )

    '' Function: PostIncrement
    '' Moves the iterator forward in the list after returning its
    '' value.
    ''
    '' Returns:
    '' Returns the value of the iterator before being incremented.
    declare function PostIncrement ( ) as fbe_ListIterator__compiler

    '' Function: PostDecrement
    '' Moves the iterator backward in the list after returning its
    '' value.
    ''
    '' Returns:
    '' Returns the value of the iterator before being decremented.
    declare function PostDecrement ( ) as fbe_ListIterator__compiler


    ' public for easy List access..
    m_node as ListNode__ ptr
end type

    '' Class: ListIteratorToConst__
type fbe_ListIteratorToConst__compiler
public:
    '' Sub: conversion from ListIterator__ constructor
    '' Constructs an iterator.
    declare constructor ( byref x as const fbe_ListIterator__compiler )

    '' Sub: default constructor
    '' Constructs an iterator.
    ''
    '' Parameters:
    '' node - the List node to point to, used internally by List
    declare constructor ( byval node as const ListNode__ ptr = null )

    '' Function: Get
    '' Gets a pointer that is constant to the referenced element.
    declare function Get ( ) as const compiler ptr

    '' Sub: Increment
    '' Moves the iterator forward in the list.
    declare sub Increment ( )

    '' Sub: Decrement
    '' Moves the iterator backward in the list.
    declare sub Decrement ( )

    '' Function: PostIncrement
    '' Moves the iterator forward in the list after returning its
    '' value.
    ''
    '' Returns:
    '' Returns the value of the iterator before being incremented.
    declare function PostIncrement ( ) as fbe_ListIteratorToConst__compiler

    '' Function: PostDecrement
    '' Moves the iterator backward in the list after returning its
    '' value.
    ''
    '' Returns:
    '' Returns the value of the iterator before being decremented.
    declare function PostDecrement ( ) as fbe_ListIteratorToConst__compiler


    ' public for easy List access..
    m_node as ListNode__ ptr
end type

'' Operator: dereference
'' Equivalent to `fbe_ListIterator__compiler.Get()`.
declare operator * ( byref self as const fbe_ListIterator__compiler ) as compiler ptr
'' Operator: dereference
'' Equivalent to `fbe_ListIteratorToConst__compiler.Get()`.
declare operator * ( byref self as const fbe_ListIteratorToConst__compiler ) as const compiler ptr

'' Function: global operator =
'' Compares two iterators for equality.
''
'' Parameters:
'' x - an iterator
'' y - another iterator
''
'' Returns:
'' Returns true if the iterators point to the same element, false
'' otherwise.
declare operator = ( byref x as fbe_ListIterator__compiler, byref y as fbe_ListIterator__compiler ) as boolean
declare operator = ( byref x as fbe_ListIteratorToConst__compiler, byref y as fbe_ListIteratorToConst__compiler ) as boolean

'' Function: global operator <>
'' Compares two iterators for inequality.
''
'' Parameters:
'' x - an iterator
'' y - another iterator
''
'' Returns:
'' Returns true if the iterators do not point to the same element,
'' false otherwise.
declare operator <> ( byref x as fbe_ListIterator__compiler, byref y as fbe_ListIterator__compiler ) as boolean
declare operator <> ( byref x as fbe_ListIteratorToConst__compiler, byref y as fbe_ListIteratorToConst__compiler ) as boolean

type fbe_Allocator_compiler
    public:
        '' Sub: constructor
        ''  Constructs an allocator object.
        declare constructor ( )
        
        '' Sub: constructor
        ''  Constructs an allocator object from another. The new allocator
        ''  object can deallocate memory allocated by the other allocator
        ''  object, and vice-versa.
        declare constructor ( byref x as const fbe_Allocator_compiler )
        
        '' Sub: destructor
        ''  Destructs the allocator object.
        declare destructor ( )
        
        '' Function: Allocate
        ''  Acquires memory for an array of *n* number of *T_* objects.
        ''
        '' Parameters:
        ''  n - the number of objects in the array.
        ''  hint - ignored.
        ''
        '' Returns:
        ''  Returns the address of the first object in the array.
        declare function Allocate ( byval n as uinteger, byval hint as compiler ptr = 0 ) as compiler ptr
        
        '' Sub: DeAllocate
        ''  Frees the memory of the array starting at the address *p*,
        ''  which contains *n* number of *T_* objects.
        ''
        '' Parameters:
        ''  p - the address of the first object.
        ''  n - the number of objects contained within the memory.
        declare sub DeAllocate ( byval p as compiler ptr, byval n as uinteger )
        
        '' Sub: Construct
        ''  Copy constructs an object at address *p* with *value*.
        ''
        '' Parameters:
        ''  p - the address of the object to construct.
        ''  value - the value to construct the object with.
        declare sub Construct ( byval p as compiler ptr, byref value as const compiler )
        
        '' Sub: Destroy
        ''  Destroys the object at address *p* by calling its destructor.
        ''
        '' Parameters:
        ''  p - the address of the object to destroy.
        declare sub Destroy ( byval p as compiler ptr )
    
    private:
        ' "Type cannot be empty" workaround.
        m_unused as integer
end type

type fbe_Allocator_fbe_ListNode__compiler
public:
    '' Sub: constructor
    ''  Constructs an allocator object.
    declare constructor ( )
    
    '' Sub: constructor
    ''  Constructs an allocator object from another. The new allocator
    ''  object can deallocate memory allocated by the other allocator
    ''  object, and vice-versa.
    declare constructor ( byref x as const fbe_Allocator_fbe_ListNode__compiler )
    
    '' Sub: destructor
    ''  Destructs the allocator object.
    declare destructor ( )
    
    '' Function: Allocate
    ''  Acquires memory for an array of *n* number of *T_* objects.
    ''
    '' Parameters:
    ''  n - the number of objects in the array.
    ''  hint - ignored.
    ''
    '' Returns:
    ''  Returns the address of the first object in the array.
    declare function Allocate ( byval n as uinteger, byval hint as fbe_ListNode__compiler ptr = 0 ) as fbe_ListNode__compiler ptr
    
    '' Sub: DeAllocate
    ''  Frees the memory of the array starting at the address *p*,
    ''  which contains *n* number of *T_* objects.
    ''
    '' Parameters:
    ''  p - the address of the first object.
    ''  n - the number of objects contained within the memory.
    declare sub DeAllocate ( byval p as fbe_ListNode__compiler ptr, byval n as uinteger )
    
    '' Sub: Construct
    ''  Copy constructs an object at address *p* with *value*.
    ''
    '' Parameters:
    ''  p - the address of the object to construct.
    ''  value - the value to construct the object with.
    declare sub Construct ( byval p as fbe_ListNode__compiler ptr, byref value as const fbe_ListNode__compiler )
    
    '' Sub: Destroy
    ''  Destroys the object at address *p* by calling its destructor.
    ''
    '' Parameters:
    ''  p - the address of the object to destroy.
    declare sub Destroy ( byval p as fbe_ListNode__compiler ptr )

private:
    ' "Type cannot be empty" workaround.
    m_unused as integer
end type

type fbe_List_compiler
public:
    declare static function Iterator as fbe_ListIterator__compiler
    declare static function IteratorToConst as fbe_ListIteratorToConst__compiler

    '' Sub: default constructor
    '' Constructs an empty list.
    declare constructor ( )

    '' Sub: copy constructor
    '' Constructs an empty list.
    declare constructor ( byref x as const fbe_List_compiler )

    '' Sub: constructor
    '' Constructs a list of n blank elements.
    ''
    '' Parameters:
    '' n - <uinteger> specifing how many elements to create.
    declare constructor ( byval n as uinteger )

    '' Sub: constructor
    '' Constructs a list of n elements with the same value.
    ''
    '' Parameters:
    '' n - <uinteger> specifing how many elements to create.
    '' value - the value to assign to each element.
    declare constructor ( byval n as uinteger, byref valu as const compiler)

    '' Sub: constructor
    '' Constructs a list from a range of list element values.
    ''
    '' Parameters:
    '' first - an iterator to the first element in the range
    '' last - an iteratot to one-past the last element in the range
    declare constructor ( byval first as typeof(IteratorToConst), byval last as typeof(IteratorToConst) )

    '' Sub: destructor
    '' Destroys the list.
    declare destructor ( )

    '' Sub: operator let
    '' Assigns to the list from another.
    ''
    '' Parameters:
    '' x - the list to assign
    declare operator let ( byref x as const fbe_List_compiler )

    '' Sub: Assign
    '' Assigns to the list from a range of list element values.
    ''
    '' Parameters:
    '' first - an iterator to the first element in the range
    '' last - an iteratot to one-past the last element in the range
    declare sub Assign ( byval first as typeof(IteratorToConst), byval last as typeof(IteratorToConst) )

    '' Sub: Assign
    '' Assigns to the list multiple copies of an element value.
    ''
    '' Parameters:
    '' n - the number of element values to assign
    '' x - the element value to assign
    declare sub Assign ( byval n as uinteger, byref x as const compiler )

    '' Function: Size
    '' Gets the number of elements in the list.
    declare const function Size ( ) as uinteger

    '' Sub: Resize
    '' Changes the size of the list. If x is greater than the current size new items are given the default value, if smaller the overhanging items are removed.
    ''
    '' Parameters:
    '' x - <uinteger> specifing the number of elements the list will contain
    declare sub Resize ( byval x as uinteger )

    '' Sub: Resize
    '' Changes the size of the list. If x is greater than the current size then new items are assigned the value passed or removed.
    ''
    '' Parameters:
    '' x - <uinteger> specifing the number of elements the list will contain
    '' v - value any new items will contain
    declare sub Resize ( byval x as uinteger, byref v as const compiler )

    '' Function: Empty
    '' Determines if the list contains no elements.
    declare const function Empty ( ) as boolean

    '' Function: Begin
    '' Gets an iterator to the first element in the list.
    declare function Begin ( ) as typeof(Iterator)
    '' Function: cBegin
    '' Gets an iterator to the first element in the list.
    declare const function cBegin ( ) as typeof(IteratorToConst)

    '' Function: End_
    '' Gets an iterator to one-past the last element in the list.
    declare function End_ ( ) as typeof(Iterator)
    '' Function: cEnd
    '' Gets an iterator to one-past the last element in the list.
    declare const function cEnd ( ) as typeof(IteratorToConst)

    '' Function: Front
    '' Gets a reference to the first element in the list.
    declare function Front ( ) as compiler ptr
    '' Function: cFront
    '' Gets a reference to the first element in the list.
    declare const function cFront ( ) as const compiler ptr

    '' Function: Back
    '' Gets a reference to the last element in the list.
    declare function Back ( ) as compiler ptr
    '' Function: cBack
    '' Gets a reference to the last element in the list.
    declare const function cBack ( ) as const compiler ptr

    '' Sub: PushFront
    '' Inserts an element value at the beginning of the list.
    ''
    '' Parameters:
    '' x - the element value to insert
    declare sub PushFront ( byref x as const compiler )

    '' Sub: PushBack
    '' Inserts an element value at the end of the list.
    ''
    '' Parameters:
    '' x - the element value to insert
    declare sub PushBack ( byref x as const compiler )

    '' Sub: PopFront
    '' Removes the first element in the list.
    declare sub PopFront ( )

    '' Sub: PopBack
    '' Removes the last element in the list.
    declare sub PopBack ( )

    '' Function: Insert
    '' Inserts an element value into the list.
    ''
    '' Parameters:
    '' position - an iterator to where insertion will take place
    '' x - the element value to insert
    ''
    '' Returns:
    '' Returns an iterator to the newly inserted element.
    declare function Insert ( byval position as typeof(Iterator), byref x as const compiler ) as typeof(Iterator)

    '' Sub: Insert
    '' Inserts a number of copies of an element value in the list.
    ''
    '' Parameters:
    '' position - an iterator to where insertion will take place
    '' n - the number of copies to insert
    '' x - the element value to insert
    declare sub Insert ( byval position as typeof(Iterator), byval n as uinteger, byref x as const compiler )

    '' Sub: Insert
    '' Inserts a range of element values into the list.
    ''
    '' Parameters:
    '' position - an iterator to where insertion will take place
    '' first - an iterator to the first element in the range to insert
    '' last - an iterator to one-past the last element in the range to
    '' insert
    declare sub Insert ( byval position as typeof(Iterator), byval first as typeof(IteratorToConst), byval last as typeof(IteratorToConst) )

    '' Sub: Splice
    '' Moves the elements of the passed list into the list at the position specified.
    ''
    '' Parameters:
    '' position - an iterator where the list insertion will take place
    '' lst - the list to insert
    ''
    declare sub Splice ( byval position as typeof(Iterator), byref lst as fbe_List_compiler )

    '' Sub: Splice
    '' Moves the elements of list "b" into list "a" at the position specified in list "a" starting at the position in the list "b".
    ''
    '' Parameters:
    '' position - an iterator where list "a" insertion will take place
    '' lst - the list to insert
    '' frst - an iterator where values from list "b" will be moved to list "a"
    ''
    declare sub Splice ( byval position as typeof(Iterator), byref lst as fbe_List_compiler, byval frst as typeof(Iterator) )

    '' Sub: Splice
    '' Moves the elements of list "b" into list "a" at the position specified in list "a" starting at the position in the list "b" and continuing until lastp.
    ''
    '' Parameters:
    '' position - an iterator where list "a" insertion will take place
    '' lst - the list to insert
    '' frst - an iterator where values from list "b" will be moved to list "a"
    '' lastp - an iterator where moving should end.
    ''
    declare sub Splice ( byval position as typeof(Iterator), byref lst as fbe_List_compiler, byval frst as typeof(Iterator), byval lastp as typeof(Iterator) )

    '' Function: Erase
    '' Removes an element from the list.
    ''
    '' Parameters:
    '' position - an iterator to the element to remove
    ''
    '' Returns:
    '' Returns an iterator to the element after the element removed, or
    '' List.End_() if the last element was removed.
    declare function Erase ( byval position as typeof(Iterator) ) as typeof(Iterator)

    '' Function: Erase
    '' Removes a range of elements from the list.
    ''
    '' Parameters:
    '' first - an iterator to the first element to remove
    '' last - an iterator to one-past the last element to remove
    ''

    '' Returns:
    '' Returns an iterator to the element after the elements removed,
    '' or List.End_() if the trailing elements were removed.
    declare function Erase ( byval first as typeof(Iterator), byval last as typeof(Iterator) ) as typeof(Iterator)

    '' Sub: Clear
    '' Removes all elements from the list.
    declare sub Clear ( )

    '' Sub: RemoveIf
    '' Removes elements from the list satisfying a predicate.
    ''
    '' Parameters:
    '' pred - a predicate that returns true if an element is to be
    '' removed, false otherwise.
    declare sub RemoveIf ( byval pred as function ( byref as const compiler ) as boolean )

private:
    declare static function T_Allocator as fbe_Allocator_compiler
    declare function m_CreateNode ( ) as ListNode__ ptr
    declare function m_CreateNode ( byref x as const compiler ) as ListNode__ ptr

    m_alloc as fbe_Allocator_fbe_ListNode__compiler
    m_node as ListNode__
end type

    #endif
