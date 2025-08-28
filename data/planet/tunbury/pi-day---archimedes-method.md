---
title: Pi Day - Archimedes Method
description: "It\u2019s Pi Day 2025"
url: https://www.tunbury.org/2025/03/14/pi-day/
date: 2025-03-14T13:00:00-00:00
preview_image: https://www.tunbury.org/images/pi.png
authors:
- Mark Elvers
source:
ignore:
---

<p>It’s <a href="https://en.wikipedia.org/wiki/Pi_Day">Pi Day</a> 2025</p>

<p>Archimedes calculated the perimeter of inscribed regular polygons
within a circle to approximate the value of π.</p>

<p>A square inscribed in a unit circle can be divided into four right
triangles with two sides of unit length, corresponding to the radius of
the circle.  The third side can be calculated by Pythagoras’ theorem to
be √2.  The perimeter of the square would be 4√2.  Given, C=πd, we
can calculate π from the circumference by dividing it by the diameter,
2, giving 2√2.</p>

<p><img src="https://www.tunbury.org/images/pi-archimedes-triangle.png" alt=""></p>

<p>CA, CD and CB are all the unit radius. AB is √2 as calculated above. The
angle ACB can be bisected with the line CD. EB is half of AB. Using
Pythagoras’ theorem on the triangle BCE we can calculated CE. DE is then
1 - CE, allowing us to use Pythagoras’ theorem for a final time on BDE to
calculated BD. The improved approximation of the perimeter is now 8 x BD.</p>

<p>We can iterate on this process using the following code:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span> <span class="k">rec</span> <span class="n">pi</span> <span class="n">edge_squared</span> <span class="n">sides</span> <span class="o">=</span> <span class="k">function</span>
  <span class="o">|</span> <span class="mi">0</span> <span class="o">-&gt;</span> <span class="n">sides</span> <span class="o">*.</span> <span class="nn">Float</span><span class="p">.</span><span class="n">sqrt</span><span class="p">(</span><span class="n">edge_squared</span><span class="p">)</span> <span class="o">/.</span> <span class="mi">2</span><span class="o">.</span>
  <span class="o">|</span> <span class="n">n</span> <span class="o">-&gt;</span>
    <span class="k">let</span> <span class="n">edge_squared</span> <span class="o">=</span> <span class="mi">2</span><span class="o">.</span> <span class="o">-.</span> <span class="mi">2</span><span class="o">.</span> <span class="o">*.</span> <span class="nn">Float</span><span class="p">.</span><span class="n">sqrt</span> <span class="p">(</span><span class="mi">1</span><span class="o">.</span> <span class="o">-.</span> <span class="n">edge_squared</span> <span class="o">/.</span> <span class="mi">4</span><span class="o">.</span><span class="p">)</span> <span class="k">in</span>
    <span class="k">let</span> <span class="n">sides</span> <span class="o">=</span> <span class="n">sides</span> <span class="o">*.</span> <span class="mi">2</span><span class="o">.</span> <span class="k">in</span>
    <span class="n">pi</span> <span class="n">edge_squared</span> <span class="n">sides</span> <span class="p">(</span><span class="n">n</span> <span class="o">-</span> <span class="mi">1</span><span class="p">)</span>

<span class="k">let</span> <span class="n">approximation</span> <span class="o">=</span> <span class="n">pi</span> <span class="mi">2</span><span class="o">.</span> <span class="mi">4</span><span class="o">.</span> <span class="mi">13</span>
<span class="k">let</span> <span class="bp">()</span> <span class="o">=</span> <span class="nn">Printf</span><span class="p">.</span><span class="n">printf</span> <span class="s2">"pi %.31f</span><span class="se">\n</span><span class="s2">"</span> <span class="n">approximation</span>
</code></pre></div></div>

<p>I found this method quite interesting. Usually, as the number of
iterations increases the approximation of π becomes more accurate
with the delta between each step becoming smaller until the difference
is effectively zero (given the limited precision of the floating
calculation).  However, in this case, after 13 iterations the
approximation becomes worse!</p>

<table>
  <thead>
    <tr>
      <th>iteration</th>
      <th>approximation</th>
      <th>% error</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>0</td>
      <td>2.8284271247461902909492437174777</td>
      <td>9.968368</td>
    </tr>
    <tr>
      <td>1</td>
      <td>3.0614674589207178101446515938733</td>
      <td>2.550464</td>
    </tr>
    <tr>
      <td>2</td>
      <td>3.1214451522580528575190328410827</td>
      <td>0.641315</td>
    </tr>
    <tr>
      <td>3</td>
      <td>3.1365484905459406483885231864406</td>
      <td>0.160561</td>
    </tr>
    <tr>
      <td>4</td>
      <td>3.1403311569547391890466769837076</td>
      <td>0.040155</td>
    </tr>
    <tr>
      <td>5</td>
      <td>3.1412772509327568926096319046337</td>
      <td>0.010040</td>
    </tr>
    <tr>
      <td>6</td>
      <td>3.1415138011441454679584239784162</td>
      <td>0.002510</td>
    </tr>
    <tr>
      <td>7</td>
      <td>3.1415729403678827047485810908256</td>
      <td>0.000627</td>
    </tr>
    <tr>
      <td>8</td>
      <td>3.1415877252799608854161306226160</td>
      <td>0.000157</td>
    </tr>
    <tr>
      <td>9</td>
      <td>3.1415914215046352175875199463917</td>
      <td>0.000039</td>
    </tr>
    <tr>
      <td>10</td>
      <td>3.1415923456110768086091411532834</td>
      <td>0.000010</td>
    </tr>
    <tr>
      <td>11</td>
      <td>3.1415925765450043449789063743083</td>
      <td>0.000002</td>
    </tr>
    <tr>
      <td>12</td>
      <td>3.1415926334632482408437681442592</td>
      <td>0.000001</td>
    </tr>
    <tr>
      <td>13</td>
      <td>3.1415926548075892021927302266704</td>
      <td>-0.000000</td>
    </tr>
    <tr>
      <td>14</td>
      <td>3.1415926453212152935634549066890</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <td>15</td>
      <td>3.1415926073757196590463536267634</td>
      <td>0.000001</td>
    </tr>
    <tr>
      <td>16</td>
      <td>3.1415929109396727447744979144773</td>
      <td>-0.000008</td>
    </tr>
    <tr>
      <td>17</td>
      <td>3.1415941251951911006301543238806</td>
      <td>-0.000047</td>
    </tr>
    <tr>
      <td>18</td>
      <td>3.1415965537048196054570325941313</td>
      <td>-0.000124</td>
    </tr>
    <tr>
      <td>19</td>
      <td>3.1415965537048196054570325941313</td>
      <td>-0.000124</td>
    </tr>
    <tr>
      <td>20</td>
      <td>3.1416742650217575061333263874985</td>
      <td>-0.002598</td>
    </tr>
    <tr>
      <td>21</td>
      <td>3.1418296818892015309643284126651</td>
      <td>-0.007545</td>
    </tr>
    <tr>
      <td>22</td>
      <td>3.1424512724941338071005247911671</td>
      <td>-0.027331</td>
    </tr>
    <tr>
      <td>23</td>
      <td>3.1424512724941338071005247911671</td>
      <td>-0.027331</td>
    </tr>
    <tr>
      <td>24</td>
      <td>3.1622776601683795227870632515987</td>
      <td>-0.658424</td>
    </tr>
    <tr>
      <td>25</td>
      <td>3.1622776601683795227870632515987</td>
      <td>-0.658424</td>
    </tr>
    <tr>
      <td>26</td>
      <td>3.4641016151377543863532082468737</td>
      <td>-10.265779</td>
    </tr>
    <tr>
      <td>27</td>
      <td>4.0000000000000000000000000000000</td>
      <td>-27.323954</td>
    </tr>
    <tr>
      <td>28</td>
      <td>0.0000000000000000000000000000000</td>
      <td>100.000000</td>
    </tr>
  </tbody>
</table>

<p>Using the <a href="https://opam.ocaml.org/packages/decimal/">decimal</a> package
we can specify the floating point precision we want allowing us to
get to 100 decimal places in 165 steps.</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">open</span> <span class="nc">Decimal</span>

<span class="k">let</span> <span class="n">context</span> <span class="o">=</span> <span class="nn">Context</span><span class="p">.</span><span class="n">make</span> <span class="o">~</span><span class="n">prec</span><span class="o">:</span><span class="mi">200</span> <span class="bp">()</span>
<span class="k">let</span> <span class="n">two</span> <span class="o">=</span> <span class="n">of_int</span> <span class="mi">2</span>
<span class="k">let</span> <span class="n">four</span> <span class="o">=</span> <span class="n">of_int</span> <span class="mi">4</span>

<span class="k">let</span> <span class="k">rec</span> <span class="n">pi</span> <span class="n">edge_squared</span> <span class="n">sides</span> <span class="n">n</span> <span class="o">=</span>
  <span class="k">match</span> <span class="n">n</span> <span class="k">with</span>
  <span class="o">|</span> <span class="mi">0</span> <span class="o">-&gt;</span> <span class="n">mul</span> <span class="o">~</span><span class="n">context</span> <span class="n">sides</span> <span class="p">(</span><span class="n">div</span> <span class="o">~</span><span class="n">context</span> <span class="p">(</span><span class="n">sqrt</span> <span class="o">~</span><span class="n">context</span> <span class="n">edge_squared</span><span class="p">)</span> <span class="n">two</span><span class="p">)</span>
  <span class="o">|</span> <span class="n">n</span> <span class="o">-&gt;</span>
      <span class="k">let</span> <span class="n">edge_squared</span> <span class="o">=</span>
        <span class="n">sub</span> <span class="o">~</span><span class="n">context</span> <span class="n">two</span>
          <span class="p">(</span><span class="n">mul</span> <span class="o">~</span><span class="n">context</span> <span class="n">two</span>
             <span class="p">(</span><span class="n">sqrt</span> <span class="o">~</span><span class="n">context</span> <span class="p">(</span><span class="n">sub</span> <span class="o">~</span><span class="n">context</span> <span class="n">one</span> <span class="p">(</span><span class="n">div</span> <span class="o">~</span><span class="n">context</span> <span class="n">edge_squared</span> <span class="n">four</span><span class="p">))))</span>
      <span class="k">in</span>
      <span class="k">let</span> <span class="n">sides</span> <span class="o">=</span> <span class="n">mul</span> <span class="o">~</span><span class="n">context</span> <span class="n">sides</span> <span class="n">two</span> <span class="k">in</span>
      <span class="n">pi</span> <span class="n">edge_squared</span> <span class="n">sides</span> <span class="p">(</span><span class="nn">Int</span><span class="p">.</span><span class="n">pred</span> <span class="n">n</span><span class="p">)</span>

<span class="k">let</span> <span class="bp">()</span> <span class="o">=</span> <span class="n">pi</span> <span class="n">two</span> <span class="n">four</span> <span class="mi">165</span> <span class="o">|&gt;</span> <span class="n">to_string</span> <span class="o">~</span><span class="n">context</span> <span class="o">|&gt;</span> <span class="nn">Printf</span><span class="p">.</span><span class="n">printf</span> <span class="s2">"%s</span><span class="se">\n</span><span class="s2">"</span>
</code></pre></div></div>

<p>This code is available on <a href="https://github.com/mtelvers/pi-archimedes">GitHub</a></p>
