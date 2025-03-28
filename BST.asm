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
	mov		rdx, qword ptr [rbp + rdi * 8]
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
	mov		rdx, qword ptr [rbp + rdi * 8]
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
	mov		8 [rsp], rcx
	mov		16 [rsp], rdx

	push	rbx

	sub		rsp, 32

	mov		rbx, rcx

	test	rcx, rcx
	jnz		c0

	mov		cl, 24
	call	malloc

	test	rax, rax
	jz		Error

	mov		rbx, rax
	mov		rax, 56 [rsp]
	mov		[rbx], rax
	mov		qword ptr 8 [rbx], 0
	mov		qword ptr 16 [rbx], 0

	jmp		done
c0:
	cmp		rdx, [rbx]
	jb		l0
	ja		g0

	jmp		done
l0:
	mov		rcx, 8 [rcx]
	call	insertBST
	mov		8 [rbx], rax

	jmp		done
g0:
	mov		rcx, 16 [rcx]
	call	insertBST
	mov		16 [rbx], rax
done:
	mov		rax, rbx

	add		rsp, 32

	pop		rbx

	ret
Error:
	mov		ecx, 1
	call	ExitProcess
insertBST		endp
countBST		proc
	mov		8 [rsp], rcx

	push	rbx
	push	rbp
	
	sub		rsp, 24

	mov		rbx, rcx
	
	test	rcx, rcx
	jnz		f0

	xor		eax, eax
	jmp		done
f0:
	mov		rcx, 8 [rcx]
	call	countBST
	mov		rbp, rax

	mov		rcx, 16 [rbx]
	call	countBST
	
	lea		rax, [rax + rbp + 1]
done:
	add		rsp, 24

	pop		rbp
	pop		rbx
	
	ret
countBST		endp
inorderBST		proc
	mov		8 [rsp], rcx
	mov		16 [rsp], rdx
	mov		24 [rsp], r8

	push	rbx

	sub		rsp, 32

	mov		rbx, rcx

	test	rcx, rcx
	jz		done

	mov		rcx, 8 [rcx]
	call	inorderBST

	mov		rax, [rbx]
	mov		rcx, [r8]
	mov		[rdx + rcx * 8], rax
	inc		rcx
	mov		[r8], rcx

	mov		rcx, 16 [rbx]
	call	inorderBST
done:
	add		rsp, 32

	pop		rbx
	
	ret
inorderBST		endp
findMinBST		proc
l0:
	test	rcx, rcx
	jz		done

	cmp		qword ptr 8 [rcx], 0
	jz		done

	mov		rcx, 8 [rcx]

	jmp		l0
done:
	mov		rax, rcx

	ret
findMinBST		endp
eraseBST		proc
	mov		8 [rsp], rcx
	mov		16 [rsp], rdx

	push	rbx
	push	rbp

	sub		rsp, 24
	
	mov		rbx, rcx
	mov		rbp, rdx
	
	test	rcx, rcx
	jnz		c1

	xor		eax, eax

	jmp		done
c1:
	cmp		rdx, [rbx]
	ja		g0
	je		e0

	mov		rcx, 8 [rcx]
	call	eraseBST
	mov		8 [rbx], rax

	mov		rax, rbx
	
	jmp		done
g0:
	mov		rcx, 16 [rcx]
	call	eraseBST
	mov		16 [rbx], rax

	mov		rax, rbx

	jmp		done
e0:
	cmp		qword ptr 8 [rcx], 0
	jnz		c2

	mov		rbp, 16 [rcx]
	
	call	free

	mov		rax, rbp

	jmp		done
c2:
	cmp		qword ptr 16 [rcx], 0
	jnz		c3

	mov		rbp, 8 [rcx]
	
	call	free

	mov		rax, rbp

	jmp		done
c3:
	mov		rcx, 16 [rcx]
	call	findMinBST

	mov		rax, [rax]
	mov		[rbx], rax

	mov		rcx, 16 [rbx]
	mov		rdx, rax
	call	eraseBST
	mov		16 [rbx], rax

	mov		rax, rbx
done:
	add		rsp, 24

	pop		rbp
	pop		rbx
	
	ret
eraseBST		endp
freeBST			proc
	mov		8 [rsp], rcx

	push	rbx
	
	sub		rsp, 32

	mov		rbx, rcx
	
	test	rcx, rcx
	jz		done

	mov		rcx, 8 [rcx]
	call	freeBST

	mov		rcx, 16 [rbx]
	call	freeBST

	mov		rcx, rbx
	call	free
done:
	add		rsp, 32

	pop		rbx

	ret
freeBST			endp
insertBSTString	proc
	mov		8 [rsp], rcx
	mov		16 [rsp], rdx
	
	push	rbx
	push	rdi
	push	rsi

	sub		rsp, 16

	mov		rbx, rcx

	test	rcx, rcx
	jnz		c0
	
	mov		cl, 24
	call	malloc

	test	rax, rax
	jz		Error

	mov		rbx, rax
	mov		rcx, 56 [rsp]
	call	_strdup

	mov		[rbx], rax
	mov		qword ptr 8 [rbx], 0
	mov		qword ptr 16 [rbx], 0

	jmp		done
c0:
	mov		rdi, [rcx]
	xor		eax, eax
	mov		ecx, 256
	mov		r8d, ecx
	repne	scasb

	sub		r8w, cx
	dec		r8w
	mov		cx, r8w
	mov		rdi, [rbx]
	mov		rsi, rdx
	repe	cmpsb
	jb		l0
	ja		g0

	jmp		done
l0:
	mov		rcx, 8 [rbx]
	call	insertBSTString
	mov		8 [rbx], rax

	jmp		done
g0:
	mov		rcx, 16 [rbx]
	call	insertBSTString
	mov		16 [rbx], rax
done:
	mov		rax, rbx

	add		rsp, 16

	pop		rsi
	pop		rdi
	pop		rbx

	ret
Error:
	mov		ecx, 1
	call	ExitProcess
insertBSTString	endp
eraseBSTString	proc
	mov		8 [rsp], rcx
	mov		16 [rsp], rdx

	push	rbx
	push	rbp
	push	rdi
	push	rsi

	sub		rsp, 8

	mov		rbx, rcx
	
	test	rcx, rcx
	jnz		c1

	xor		eax, eax

	jmp		done
c1:
	mov		rdi, rdx
	xor		eax, eax
	mov		ecx, 256
	mov		r8d, ecx
	repne	scasb
	
	sub		r8w, cx
	mov		cx, r8w
	mov		rdi, [rbx]
	mov		rsi, rdx
	repe	cmpsb
	ja		g0
	je		e0

	mov		rcx, 8 [rbx]
	call	eraseBSTString
	mov		8 [rbx], rax

	mov		rax, rbx
	
	jmp		done
g0:
	mov		rcx, 16 [rbx]
	call	eraseBSTString
	mov		16 [rbx], rax

	mov		rax, rbx

	jmp		done
e0:
	cmp		qword ptr 8 [rbx], 0
	jnz		c2

	mov		rbp, 16 [rbx]
	
	mov		rcx, rbx
	call	free

	mov		rax, rbp

	jmp		done
c2:
	cmp		qword ptr 16 [rbx], 0
	jnz		c3

	mov		rbp, 8 [rbx]
	
	mov		rcx, rbx
	call	free

	mov		rax, rbp

	jmp		done
c3:
	mov		rcx, 16 [rbx]
	call	findMinBST
	mov		rbp, [rax]

	mov		rcx, [rbx]
	call	free

	mov		rcx, [rbp]
	call	_strdup

	test	rax, rax
	jz		Error

	mov		[rbx], rax

	mov		rcx, 16 [rbx]
	mov		rdx, [rbp]
	call	eraseBST
	mov		16 [rbx], rax

	mov		rax, rbx
done:
	add		rsp, 8
	
	pop		rsi
	pop		rdi
	pop		rbp
	pop		rbx
	
	ret
Error:
	mov		ecx, 1
	call	ExitProcess
eraseBSTString	endp
end