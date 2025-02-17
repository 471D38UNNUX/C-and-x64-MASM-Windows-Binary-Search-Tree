malloc		proto
free		proto
_strdup		proto
printf_s	proto
ExitProcess	proto

.data
	txt			db "Count of BST nodes: %u", 10, 0
	txt1		db "In-order traversal: ", 0
	txt2		db "%lld ", 0
	txt3		db "In-order after deletion: ", 0
	txt4		db "Count of BSTString nodes: %u", 10, 0
	txt5		db "In-order string traversal: ", 0
	txt6		db "%s ", 0
	txt7		db "In-order string after deletion: ", 0
	line		dw 10
	root		dq 3 dup (?)
	arr			dq 10 dup (?)
	index		dq 0
	orange		db "orange", 0
	apple		db "apple", 0
	banana		db "banana", 0
	grape		db "grape", 0
	cherry		db "cherry", 0
	rootStr		dq 3 dup (?)
	strArr		dq 10 dup (?)
	strIndex	dq 0

.code
mainCRTStartup	proc
	sub		rsp, 40

	;	Insert integers into the BST
	lea		rbx, root

	xor		ecx, ecx
	mov		rdx, 50
	call	insertBST
	mov		rbx, rax

	mov		rcx, rbx
	mov		rdx, 50
	call	insertBST
	mov		rbx, rax

	mov		rcx, rbx
	mov		rdx, 30
	call	insertBST
	mov		rbx, rax

	mov		rcx, rbx
	mov		rdx, 70
	call	insertBST
	mov		rbx, rax

	mov		rcx, rbx
	mov		rdx, 20
	call	insertBST
	mov		rbx, rax

	mov		rcx, rbx
	mov		rdx, 40
	call	insertBST
	mov		rbx, rax

	mov		rcx, rbx
	mov		rdx, 60
	call	insertBST
	mov		rbx, rax

	mov		rcx, rbx
	mov		rdx, 80
	call	insertBST
	mov		rbx, rax

	;	Count the number of nodes
	mov		rcx, rbx
	call	countBST

	lea		rcx, txt
	mov		rdx, rax
	call	printf_s

	;	In-order traversal
	mov		rcx, rbx
	lea		rdx, arr
	lea		r8, index
	call	inorderBST

	lea		rcx, txt1
	call	printf_s

	lea		rbp, arr

	xor		edi, edi
l0:
	lea		rcx, txt2
	mov		rdx, qword ptr [rbp + rdi * 8]
	call	printf_s

	inc		dil

	cmp		rdi, index
	jl		l0

	lea		rcx, line
	call	printf_s

	;	Delete a node
	mov		rcx, rbx
	mov		rdx, 50
	call	eraseBST

	;	In-order traversal after deletion
	mov		index, 0

	mov		rcx, rbx
	lea		rdx, arr
	lea		r8, index
	call	inorderBST

	lea		rcx, txt3
	call	printf_s

	lea		rbp, arr

	xor		edi, edi
l1:
	lea		rcx, txt2
	mov		rdx, qword ptr [rbp + rdi * 8]
	call	printf_s

	inc		dil

	cmp		rdi, index
	jl		l1

	lea		rcx, line
	call	printf_s

	;	Free the tree
	mov		rcx, rbx
	call	freeBST

	;	---- STRING BST ----
	;	Insert strings
	lea		rbx, rootStr

	xor		ecx, ecx
	lea		rdx, orange
	mov		r8, sizeof orange
	call	insertBSTString
	mov		rbx, rax

	mov		rcx, rbx
	lea		rdx, orange
	mov		r8, sizeof orange
	call	insertBSTString
	mov		rbx, rax

	mov		rcx, rbx
	lea		rdx, apple
	mov		r8, sizeof apple
	call	insertBSTString
	mov		rbx, rax

	mov		rcx, rbx
	lea		rdx, banana
	mov		r8, sizeof banana
	call	insertBSTString
	mov		rbx, rax

	mov		rcx, rbx
	lea		rdx, grape
	mov		r8, sizeof grape
	call	insertBSTString
	mov		rbx, rax

	mov		rcx, rbx
	lea		rdx, cherry
	mov		r8, sizeof cherry
	call	insertBSTString
	mov		rbx, rax

	;	Count nodes in string BST
	mov		rcx, rbx
	call	countBST

	lea		rcx, txt4
	mov		rdx, rax
	call	printf_s

	;	In-order traversal
	mov		rcx, rbx
	lea		rdx, strArr
	lea		r8, strIndex
	call	inorderBST

	lea		rcx, txt5
	call	printf_s

	lea		rbp, strArr

	xor		edi, edi
l2:
	lea		rcx, txt6
	lea		rdx, qword ptr [rbp + rdi * 8]
	call	printf_s

	inc		dil

	cmp		rdi, strIndex
	jl		l2

	lea		rcx, line
	call	printf_s

	;	Delete a string node
	mov		rcx, rbx
	lea		rdx, banana
	mov		r8, sizeof banana
	call	eraseBSTString

	;	In-order traversal after deletion
	mov		strIndex, 0

	mov		rcx, rbx
	lea		rdx, strArr
	lea		r8, strIndex
	call	inorderBST

	lea		rcx, txt7
	call	printf_s

	lea		rbp, strArr

	xor		edi, edi
l3:
	lea		rcx, txt6
	lea		rdx, qword ptr [rbp + rdi * 8]
	call	printf_s

	inc		dil

	cmp		rdi, strIndex
	jl		l3

	lea		rcx, line
	call	printf_s

	;	Free the string BST
	mov		rcx, rbx
	call	freeBST

	xor		ecx, ecx
	call	ExitProcess
mainCRTStartup	endp
insertBST		proc
	push	rbx

	mov		rbx, rcx

	test	rcx, rcx
	jnz		cont

	push	rbp

	sub		rsp, 24

	mov		rbp, rdx
	mov		ecx, 24
	call	malloc
	mov		rbx, rax

	test	rax, rax
	jz		Error

	mov		[rbx], rbp
	mov		qword ptr 8 [rbx], 0
	mov		qword ptr 16 [rbx], 0

	add		rsp, 24

	pop		rbp

	jmp		done
cont:
	cmp		rdx, [rbx]
	jb		less
	ja		great
	je		done
less:
	mov		rcx, qword ptr 8 [rbx]
	call	insertBST
	mov		qword ptr 8 [rbx], rax

	jmp		done
great:
	mov		rcx, qword ptr 16 [rbx]
	call	insertBST
	mov		qword ptr 16 [rbx], rax
done:
	mov		rax, rbx

	pop		rbx

	ret
Error:
	mov		ecx, 1
	call	ExitProcess
insertBST		endp
countBST		proc
	test	rcx, rcx
	jnz		cont

	xor		eax, eax

	ret
cont:
	push	rbx
	push	rbp

	mov		rbx, rcx
	mov		rcx, qword ptr 8 [rbx]
	call	countBST
	mov		ebp, eax

	mov		rcx, qword ptr 16 [rbx]
	call	countBST

	inc		eax
	add		eax, ebp

	pop		rbp
	pop		rbx

	ret
countBST		endp
inorderBST		proc
	test	rcx, rcx
	jz		done

	push	rbx

	mov		rbx, rcx
	mov		rcx, qword ptr 8 [rbx]
	call	inorderBST

	mov		rbp, [rbx]
	mov		rdi, [r8]
	mov		qword ptr [rdx + rdi * 8], rbp
	inc		rdi
	mov		[r8], rdi

	mov		rcx, qword ptr 16 [rbx]
	call	inorderBST

	pop		rbx
done:
	ret
inorderBST		endp
findMinBST		proc
l0:
	test	rcx, rcx
	jz		done
	cmp		qword ptr 8 [rcx], 0
	jz		done

	mov		rcx, qword ptr 8 [rcx]
done:
	mov		rax, rcx

	ret
findMinBST		endp
eraseBST		proc
	test	rcx, rcx
	jnz		c1

	xor		eax, eax

	ret
c1:
	push	rbx
	
	mov		rbx, rcx

	cmp		rdx, [rbx]
	ja		great
	je		equal

	push	rbp

	mov		rbp, rdx
	mov		rcx, qword ptr 8 [rbx]
	mov		rdx, rbp
	call	eraseBST
	mov		qword ptr 8 [rbx], rax

	mov		rax, rbx

	pop		rbp
	
	jmp		done
great:
	push	rbp

	mov		rbp, rdx
	mov		rcx, qword ptr 16 [rbx]
	mov		rdx, rbp
	call	eraseBST
	mov		qword ptr 16 [rbx], rax

	mov		rax, rbx

	pop		rbp

	jmp		done
equal:
	cmp		qword ptr 8 [rbx], 0
	jnz		c2

	sub		rsp, 32

	mov		rdi, qword ptr 16 [rbx]
	
	mov		rcx, rbx
	call	free

	mov		rax, rdi

	add		rsp, 32

	jmp		done
c2:
	cmp		qword ptr 16 [rbx], 0
	jnz		c3
	
	sub		rsp, 32

	mov		rdi, qword ptr 8 [rbx]
	
	mov		rcx, rbx
	call	free

	mov		rax, rdi

	add		rsp, 32

	jmp		done
c3:
	mov		rcx, qword ptr 16 [rbx]
	call	findMinBST
	mov		rax, [rax]

	mov		[rbx], rax

	mov		rcx, qword ptr 16 [rbx]
	mov		rdx, rax
	call	eraseBST
	mov		qword ptr 16 [rbx], rax

	mov		rax, rbx
done:
	pop		rbx
	
	ret
eraseBST		endp
freeBST			proc
	test	rcx, rcx
	jz		done
	
	push	rbx

	sub		rsp, 32

	mov		rbx, rcx

	mov		rcx, qword ptr 8 [rbx]
	call	freeBST

	mov		rcx, qword ptr 16 [rbx]
	call	freeBST

	mov		rcx, rbx
	call	free

	add		rsp, 32

	pop		rbx
done:
	ret
freeBST			endp
insertBSTString	proc
	push	rbx

	mov		rbx, rcx

	test	rcx, rcx
	jnz		cont

	push	rbp

	sub		rsp, 24
	
	mov		rbp, rdx
	mov		ecx, 24
	call	malloc
	mov		rbx, rax

	test	rax, rax
	jz		Error

	mov		rcx, rbp
	call	_strdup
	mov		rax, [rax]
	mov		[rbx], rax

	mov		qword ptr 8 [rbx], 0
	mov		qword ptr 16 [rbx], 0

	add		rsp, 24

	pop		rbp

	jmp		done
cont:
	lea		rdi, [rbx]
	mov		rsi, rdx
	mov		rcx, r8
	repe	cmpsb
	jb		less
	ja		great
	je		done
less:
	mov		rcx, qword ptr 8 [rbx]
	call	insertBSTString
	mov		qword ptr 8 [rbx], rax

	jmp		done
great:
	mov		rcx, qword ptr 16 [rbx]
	call	insertBSTString
	mov		qword ptr 16 [rbx], rax
done:
	mov		rax, rbx

	pop		rbx

	ret
Error:
	mov		ecx, 1
	call	ExitProcess
insertBSTString	endp
eraseBSTString	proc
	test	rcx, rcx
	jnz		c1

	xor		eax, eax

	ret
c1:
	push	rbx
	
	mov		rbx, rcx

	lea		rdi, [rbx]
	mov		rsi, rdx
	mov		rcx, r8
	repe	cmpsb
	ja		great
	je		equal

	push	rbp

	mov		rbp, rdx
	mov		rcx, qword ptr 8 [rbx]
	mov		rdx, rbp
	call	eraseBSTString
	mov		qword ptr 8 [rbx], rax

	mov		rax, rbx

	pop		rbp
	
	jmp		done
great:
	push	rbp

	mov		rbp, rdx
	mov		rcx, qword ptr 16 [rbx]
	mov		rdx, rbp
	call	eraseBSTString
	mov		qword ptr 16 [rbx], rax

	mov		rax, rbx

	pop		rbp

	jmp		done
equal:
	cmp		qword ptr 8 [rbx], 0
	jnz		c2

	sub		rsp, 32

	mov		rdi, qword ptr 16 [rbx]
	
	mov		rcx, rbx
	call	free

	mov		rax, rdi

	add		rsp, 32

	jmp		done
c2:
	cmp		qword ptr 16 [rbx], 0
	jnz		c3
	
	sub		rsp, 32

	mov		rdi, qword ptr 8 [rbx]
	
	mov		rcx, rbx
	call	free

	mov		rax, rdi

	add		rsp, 32

	jmp		done
c3:
	sub		rsp, 32
	
	mov		rcx, qword ptr 16 [rbx]
	call	findMinBST
	mov		rbp, [rax]

	mov		rcx, [rbx]
	call	free

	mov		rcx, [rbp]
	call	_strdup
	mov		[rbx], rax

	mov		rcx, qword ptr 16 [rbx]
	mov		rdx, [rbp]
	call	eraseBST
	mov		qword ptr 16 [rbx], rax

	mov		rax, rbx

	add		rsp, 32
done:
	pop		rbx
	
	ret
eraseBSTString	endp
end