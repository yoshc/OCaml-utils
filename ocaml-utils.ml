(* OCaml-utils
 * ************
 * Some basic OCaml utility functions
 * I will keep updating while learning
 * functional programming
 * https://github.com/yoshc/OCaml-utils
 * ************
 *)


(* -----
 * List Module
 * ----- 
 *)
 module YList = struct

(* list_reverse : list -> list
 *
 * Reverses a given list of polymorphic type
 * Examples:  # list_reverse [1;2;3;4] = [4; 3; 2; 1]
 *            # list_reverse ["hello";"world"] = ["world"; "hello"]
 *)
 let list_reverse l =
  let rec list_reverse_rec li result =
    match li with
        []    -> result
      | x::xs -> list_reverse_rec xs (x::result)
  in list_reverse_rec l []


(* list_size : list -> int
 *
 * Returns the size of a given polymorphic list
 * Examples:  # list_size [] = 0
 *            # list_size [1;2;3] = 3
 *)
let list_size l =
  let rec list_size_rec li count =
    match li with
        []    -> count
      | x::xs -> list_size_rec xs (count+1)
  in list_size_rec l 0


(* list_index_of : list -> 'a -> int
 *
 * Returns the index where a specific element first occurs in a given
 * polymorphic list, starting at 0.
 * Returns -1 if the element is not in the list
 * Examples:  # list_index_of [1;2;3;4;5] 2 = 1
 *            # list_index_of [1;2;3;4;5] 4 = 3
 *            # list_index_of [1;2;3;4;5] 6 = -1
 *)
let list_index_of l element =
  let rec list_index_of_rec li element count =
    match li with
        []    -> -1
      | x::xs ->  if x = element then count
                  else list_index_of_rec xs element (count+1) 
  in list_index_of_rec l element 0


(* list_contains : list -> 'a -> bool
 *
 * Returns if a given polymorphic list contains a specific element
 * Examples:  # list_contains ['a';'c';'e'] 'a' = true
 *            # list_contains ['a';'c';'e'] 'b' = false
 *)
let list_contains l element =
  (list_index_of l element) >= 0


(* list_get_element : 'a list -> int -> 'a
 *
 * Returns the element at a specified index in a polymorphic list.
 * Note that index must be within [0;list_size l],
 * otherwise the function fails with "Index out of bounds"
 * Examples:  # list_get_element [2;4;6;8;10] 0 = 2
 *            # list_get_element [2;4;6;8;10] 4 = 10
 *)
let rec list_get_element l index = if index < 0 then failwith "Index out of bounds" else
  match l with
      []     -> failwith "Index out of bounds"
    | x::xs  -> if index = 0 then x else list_get_element xs (index-1)


(* list_map : ('a -> 'b) -> 'a list -> 'b list
 *
 * Applies f to each element in a given polymorphic list.
 * Examples:  # list_map (fun x -> x+1) [1;2;3;4] = [2; 3; 4; 5]
 *            # list_map string_of_int [11;12;13] = ["11"; "12"; "13"]
 *)
let rec list_map f l =
  match l with
      []     -> []
    | x::xs  -> (f x)::list_map f xs



(* list_replace_element : 'a list -> 'a -> 'a -> 'a list
 *
 * Replaces all occurrences of element1 by element2 in a polymorphic list.
 * Examples:  # list_replace_element [1;2;3] 2 4 = [1; 4; 3]
 *            # list_replace_element [1;1;1] 1 2 = [2; 2; 2]
 *)
let rec list_replace_element l element1 element2 =
  match l with
      []     -> []
    | x::xs  -> (if x = element1 then element2 else x)::list_replace_element xs element1 element2


(* list_set_at_index : 'a list -> int -> 'a -> 'a list
 *
 * Sets the list element with a given index to a given value (named element)
 * Examples:  # list_set_at_index [0;1;2;3;4] 4 99 = [0; 1; 2; 3; 99]
 *            # list_set_at_index [0;1;2;3;4] 0 10 = [10; 1; 2; 3; 4]
 * Returns l if the index is out of bounds
*)
let rec list_set_at_index l index elem =
  match l with
    | []    -> []
    | x::xs -> if index = 0 then elem::(list_set_at_index xs (index-1) elem) else x::(list_set_at_index xs (index-1) elem)

(* End of List module*)
end


(* -----
 * Sequences Module
 * ----- 
 *)
module YSequences = struct

(* fib : int -> int
 *
 * Returns fib(x) with fib being the fibonacci sequence.
 * fib(0) = fib(1) = 1 and fib(x) = fib(x-1) + fib(x-2) with x >= 2
 *)
let rec fib x =
  if x <= 1 then 1 else (fib (x-1)) + (fib (x-2))


(* fac : int -> int
 *
 * Returns x! (factorial of x)
 * 0! = 1! and x! = x * (x-1)!
 *)
let rec fac x =
  if x <= 1 then 1 else x * fac (x-1)


(* End of Sequences module*)
end


(* -----
 * Map Module (associative list)
 * Stores key-value pairs as (k,v) tuples
 * in a list. Uses option types
 * ----- 
 *)
module YMap = struct

 (* map_is_empty : 'a list -> bool
 *
 * Returns True if the map is empty, False if not
 *)
let map_is_empty map = (map = [])

(* map_get : 'a -> ('a * 'b) list -> 'b option
 *
 * Returns the value of a given key in a map.
 * Uses option type
 *)
let rec map_get key map = 
  match map with
      []        -> None
    | (k,v)::xs -> if key = k then Some v else map_get key xs

(* map_put : 'a -> 'b -> ('a * 'b) list -> ('a * 'b) list
 *
 * Inserts a key-value pair into the map.
 * Overrides existing (k,v)-tuple if it exists
 *)
let map_put key value map =
  if (List.find_opt (fun x -> let k,v = x in k = key) map) = None
    then (key,value)::map
  else List.map (fun x -> let k,v = x in (if k = key then key,value else k,v)) map

(* map_contains_key : 'a -> ('a * 'b) list -> bool
 *
 * Returns True if a given key exists in a map
 *)
let map_contains_key key map =
  map_get key map <> None

(* map_remove : 'a -> ('a * 'b) list -> ('a * 'b) list
 *
 * Removes the key-value pair with given key
 *)
let rec map_remove key map =
  match map with
      []        -> []
    | (k,v)::xs -> if key = k then map_remove key xs
                   else (k,v)::(map_remove key xs)

(* map_keys : ('a * 'b) list -> 'a list
 *
 * Returns all keys
 * (every tuple's first element)
 *)
let map_keys map =
  List.map fst map

(* map_values : ('a * 'b) list -> 'b list
 *
 * Returns all values
 * (every tuple's second element)
 *)
let map_values map =
  List.map snd map


(* End of Map module*)
end


(* -----
 * Binary tree Module
 * ----- 
 *)
module YBintree = struct

type 'a bintree = Empty | Node of 'a * 'a bintree * 'a bintree
type traverse_order = PREORDER | INORDER | POSTORDER

(* val bintree_insert : 'a -> ('a -> 'a -> int) -> 'a bintree -> 'a bintree
 *
 * Inserts a given element into a binary tree.
 * A compare function has to be provided (standard for int is Pervasives 'compare')
 *)
let rec bintree_insert (elem : 'a) (comp:('a -> 'a -> int)) (t:'a bintree) =
  match t with
    | Empty       -> Node (elem,Empty,Empty)
    | Node(e,l,r) -> if (comp elem e) < 0 then Node(e,(bintree_insert elem comp l), r)
                      else Node(e,l,(bintree_insert elem comp r))


(* val bintree_print : 'a bintree -> traverse_order -> ('a -> unit) -> unit
 *
 * Prints a given binary tree.
 *
 * Example usage:
    let b : int bintree ref = ref (Node(2, Node(1,Empty,Empty), Node(3,Empty,Empty))) in
    let () = (b := (bintree_insert 5 compare !b)) in
    let () = (b := (bintree_insert (-1) compare !b)) in
    let () = bintree_print !b INORDER (fun i -> (print_int i;print_string " ")) in
    ()
 * => Results in "-1 1 2 3 5" being printed to std output
 *)
let rec bintree_print (t:'a bintree) (o:traverse_order) (print_fun:('a->unit)) =
  match t with
    | Empty       -> ()
    | Node(e,l,r) -> if o = PREORDER then (print_fun e;(bintree_print l o print_fun);(bintree_print r o print_fun))
                     else if o = INORDER then ((bintree_print l o print_fun);print_fun e;(bintree_print r o print_fun))
                     else if o = POSTORDER then ((bintree_print l o print_fun);(bintree_print r o print_fun);print_fun e)

(* val bintree_contains : 'a -> ('a -> 'a -> int) -> 'a bintree -> bool
 *
 * Returns whether the binary tree contains a given element
 *  (tail-recursive implementation)
 *)
let rec bintree_contains (elem : 'a) (comp:('a -> 'a -> int)) (t:'a bintree) =
  match t with
    | Empty       -> false
    | Node(e,l,r) -> let cmp_result = comp elem e in
                     if cmp_result = 0 then true                              (* target element = node element -> found element *)
                     else if cmp_result < 0 then bintree_contains elem comp l (* target element < node element -> left subtree *)
                     else bintree_contains elem comp r                        (* target element > node element -> right subtree *)


(* End of Binary Tree module*)
end


(* -----
 * Basic utility functions
 * ----- 
 *)

 module YBasic = struct

(* val string_to_charlist : string -> char list 
 *
 * Splits a string into a char list
 * Example: string_to_charlist "hello!" -> ['h'; 'e'; 'l'; 'l'; 'o'; '!']
 *)
let string_to_charlist str =
  let rec impl i len =
    if i = len then [] else (String.get str i)::(impl (i+1) len)
  in impl 0 (String.length str)


(* val is_balanced : string -> bool
 *
 * Checks if a String expression is balanced in terms of its brackets.
 * (This was a exercise taken from TUM FPV WS17/18 endterm ex. 3)
 * Examples:  is_balanced ")(" -> false
 *            is_balanced "())" -> false
 *            is_balanced "a(b)((c))" -> true
 *)
let is_balanced str =
    let rec is_balanced_rec chars num_open num_closed =
        match chars with
            | []    ->  if num_open = num_closed then true else false
            | c::xs ->  if c = '(' then is_balanced_rec xs (num_open+1) num_closed
                        else if c = ')' then (if num_open <= num_closed then false else is_balanced_rec xs num_open (num_closed+1))
                        else is_balanced_rec xs num_open num_closed
    in is_balanced_rec (string_to_charlist str) 0 0

(* End of Basic module*)
end
