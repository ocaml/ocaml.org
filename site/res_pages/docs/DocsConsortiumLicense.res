let s = React.string

let default = () =>
  <>
  <h1>{s(`The OCaml License for Consortium Members`)}</h1>
  <div>
    <p>
      {s(`Copyright (c) 1996, 1997, 1998, 1999, 2000, 2001, 2002, INRIA`)}
    </p>
    <p>
      {s(`Permission is hereby granted, free of charge, to the Licensee 
      obtaining a copy of this software and associated documentation files 
      (the "Software"), to deal in the Software without restriction, 
      including without limitation the rights to use, copy, modify, merge, 
      publish, distribute, sublicense under any license of the Licensee's 
      choice, and/or sell copies of the Software, subject to the following 
      conditions:`)}
      <ol>
        <li>
          {s(`Redistributions of source code must retain the above copyright 
          notice and the following disclaimer.`)}
        </li>
        <li>
          {s(`Redistributions in binary form must reproduce the above copyright 
          notice, the following disclaimer in the documentation and/or other 
          materials provided with the distribution.`)}
        </li>
        <li>
          {s(`All advertising materials mentioning features or use of the 
          Software must display the following acknowledgement: This product 
          includes all or parts of the OCaml system developed by INRIA and its 
          contributors.`)}
        </li>
        <li>
          {s(`Other than specified in clause 3, neither the name of INRIA nor 
          the names of its contributors may be used to endorse or promote 
          products derived from the Software without specific prior written 
          permission.`)}
        </li>
      </ol>
    </p>
    <h2>{s(`Disclaimer`)}</h2>
    <p>
      {s(`THIS SOFTWARE IS PROVIDED BY INRIA AND CONTRIBUTORS "AS IS" AND ANY 
      EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
      IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR 
      PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL INRIA OR ITS CONTRIBUTORS BE 
      LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
      CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
      SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR 
      BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
      WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE 
      OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN 
      IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.`)}
    </p>
  </div>
  </>
