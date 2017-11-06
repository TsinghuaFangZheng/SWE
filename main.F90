program jacobi
	integer imax,jmax,im1,jm1,it,itmax
	parameter (imax=2001,jmax=2001)
	parameter (im1=imax-1,jm1=jmax-1)
	parameter (itmax=100)
	real*8 u(imax,jmax),du(imax,jmax),umax,dumax
	parameter (umax=10.0)

	!$omp parallel default(shared) private(i,j)
	!$omp do
	do j=1,jmax
		do i=1,imax-1
			u(i,j)=0.0
			du(i,j)=0.0
		enddo
		u(imax,j)=umax
	enddo
	!$omp end do 

	! main computation loop
	do it=1,itmax

		!$omp single
		dumax=0.0
		!$omp end single

		!$omp do reduction (max:dumax)
		do j=2,jm1
			do i=2,im1
				du(i,j)=0.25*(u(i-1,j)+u(i+1,j)+u(i,j-1)+u(i,j+1))-u(i,j)
				dumax=max(dumax,abs(du(i,j)))
			enddo
		enddo
		!$omp end do

		!$omp do
		do j=2,jm1
			do i=2,im1
				u(i,j)=u(i,j)+du(i,j)
			enddo
		enddo
		!$omp end do nowait

		!$omp master
		write (*,*) it,dumax
		!$omp end master

		!$omp barrier
	enddo

	!$omp end parallel
	stop
end
