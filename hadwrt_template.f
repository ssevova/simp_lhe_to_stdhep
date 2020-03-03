c MadGraph5 simp
c    ID IST isthep
c 1) 11  -1    0 beam
c 2)623  -1    0 target
c 3)622   2    0 A'
c 4)625   2    0 rho0
c 5) 11   1    1 recoil e-
c 6)623   1    0 target
c 7)-11   1    1 e+ from rho
c 8) 11   1    1 e- from rho
c 9)624   1    0 pi0
c 
      implicit none
c
c 
c
      include 'stdhep.inc'

      integer ntries, istream, lok
      integer i, j, k, l, ierr, nb, n
      real*8 p(5,20), pp, ui, vi, wi
      real*8 ctau, gamma, beta, dl
      integer id(20), istat(20), mo1(10), mo2(20),
     -        da1(20), da2(20), np

      integer idum
      real dum(4), rndm, vtx, spin

      character*7 tag, event/'<event>'/

      ntries = 50000

      nevhep = 0

      open(51,file='XXX_INFILE_XXX',form='FORMATTED')

      call stdxwinit('XXX_OUTFILE_XXX', ' ascii events ', 
     -     ntries, istream, lok)

c      write(6,701) istream, lok
c 701  format(2x,'init istream=',i10,' lok =',i10)

      call stdxwrt(100, istream, lok)

c      write(6,702) istream, lok
c 702  format(2x,' istream=',i10,' lok =', i10)

c     read(5,*) ctau
c     write(6,710) ctau
      ctau = XXX_CTAU_XXX
 710  format(2x,'ctau (mm)=', f10.2)

 1    continue
      read(51,*,err=999,end=999) tag

      if(tag.ne.event) go to 1

c event header
      read(51,*) np, idum, dum

      do n=1, np
         read(51,*) id(n),istat(n),mo1(n),mo2(n),da1(n),da2(n),
     -      p(1,n),p(2,n),p(3,n),p(4,n),p(5,n),vtx,spin
      end do

      nevhep = nevhep + 1

c sample decay distance
      if(ctau.gt.0.0) then
         gamma = p(4,4) / p(5,4)
         beta = sqrt(1.d0 - 1.d0/gamma**2)
         call ranlux(rndm, 1)
c dl in mm
         dl = -beta*gamma*ctau*alog(rndm)

c direction
         pp = sqrt(p(1,4)**2+p(2,4)**2+p(3,4)**2)
         ui = p(1,4) / pp
         vi = p(2,4) / pp
         wi = p(3,4) / pp
      end if
c
c skip final state target
      nhep = 8

      
      do j=1, np
         if(j.ne.6) then
            if(j.le.5) k = j
            if(j.ge.7) k = j - 1

c isthep
            if(j.le.2) isthep(k) = 3
            IF(j.eq.3.or.j.eq.4.or.j.eq.9) isthep(k) = 2
            if(j.eq.5.or.j.eq.7.or.j.eq.8) isthep(k) = 1

            idhep(k) = id(j)
            if(j.eq.2) idhep(k) = -623
            if(j.eq.3) idhep(k) =  625
            if(j.eq.4) idhep(k) =  622

            jmohep(1,k) = 0
            jmohep(2,k) = 0
            jdahep(1,k) = 0
            jdahep(2,k) = 0
c beam & target
            if(j.le.2) then
               jmohep(1,k) = 0
               jmohep(2,k) = 0
               jdahep(1,k) = 3
               jdahep(2,k) = 5
            end if
c A'
            if(j.eq.3) then
               jmohep(1,k) = 1
               jmohep(2,k) = 2

               jdahep(1,k) = 4
               jdahep(2,k) = 8
            end if
c rho
            if(j.eq.4) then
               jmohep(1,k) = 3
               jmohep(2,k) = 3

               jdahep(1,k) = 6
               jdahep(2,k) = 7
            end if
c recoil e-
            if(j.eq.5) then
               jmohep(1,k) = 1
               jmohep(2,k) = 2
            end if
c e+/e-
            if(j.eq.7.or.j.eq.8) then
               jmohep(1,k) = 4
               jmohep(2,k) = 4
            end if
c pi
            if(j.eq.9) then
               jmohep(1,k) = 3
               jmohep(2,k) = 3
            end if
c                          
         phep(1,k) = p(1,j)
         phep(2,k) = p(2,j)
         phep(3,k) = p(3,j)
         phep(4,k) = p(4,j)
         phep(5,k) = p(5,j)
c
         vhep(1,k) = 0.0
         vhep(2,k) = 0.0
         vhep(3,k) = 0.0
         vhep(4,k) = 0.0

         if(j.eq.7.or.j.eq.8) then

c vhep in mm
            vhep(1,k) = dl * ui
            vhep(2,k) = dl * vi
            vhep(3,k) = dl * wi
            vhep(4,k) = dl / beta
         end if
         end if
      end do   

         call stdxwrt(  1, istream, lok)
c         write(6,703) istream, lok
c 703     format(2x,' event istream=',i10, ' lok =',i10)
      go to 1

 999  continue
      call stdxwrt(200, istream, lok)
      call stdxend(istream)
      stop
      end
