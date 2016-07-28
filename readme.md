<h1 id="處理論文統計分析過程說明">處理論文統計分析過程說明</h1>

<hr>

<blockquote>
  <p>編輯人：鄧孝航 <br>
  聯絡信箱：<a href="402391174@mail.fju.edu.tw">402391174@mail.fju.edu.tw</a></p>
  
  <p>內容如有不當煩請告知，謝謝</p>
</blockquote>

<p>為了推廣「可重複研究<strong>(Reproducible Research)</strong>」的概念並方便將來再次研究分析，故建立此說明檔解釋相關的R語言函數及數據處理過程。有關於可重複研究的概念，可參考維基百科<a href="https://en.wikipedia.org/wiki/Reproducibility#Reproducible_research"><strong>(Reproducible Research)</strong></a>。 <br>
本分析使用R語言作為統計分析之工具，並搭配R、Rstudio、Excel、TEJ資料庫。</p>

<blockquote>
  <p>參考論文： <strong>企業競爭策略與產業競爭程度對避稅行為之影響</strong> <br>
  作者：<strong>史宗玄</strong> <br>
  指導教授：<strong>黃美祝 博士</strong></p>
</blockquote>

<p>本文僅供學術研究之用！</p>

<hr>

<h2 id="目錄">目錄</h2>

<p><div class="toc">
<ul>
<li><a href="#處理論文統計分析過程說明">處理論文統計分析過程說明</a><ul>
<li><a href="#目錄">目錄</a></li>
<li><a href="#運行前的準備">運行前的準備</a></li>
<li><a href="#實證分析">實證分析</a><ul>
<li><a href="#架構">架構</a></li>
<li><a href="#getting-data">Getting Data</a></li>
<li><a href="#preparation-for-rstudio">Preparation for RStudio</a></li>
<li><a href="#preparing-data">Preparing Data</a></li>
<li><a href="#produce-variables">Produce Variables</a></li>
<li><a href="#analyze">Analyze</a></li>
<li><a href="#produce-reports-and-graphs">Produce reports and graphs</a><ul>
<li><a href="#樣本說明">樣本說明</a><ul>
<li><a href="#表一樣本篩選表">表一、樣本篩選表</a></li>
<li><a href="#表二樣本產業與年度分配表">表二、樣本產業與年度分配表</a></li>
<li><a href="#表0按產業年份及變數分類之缺漏值數量表">表0、按產業、年份及變數分類之缺漏值數量表</a></li>
</ul>
</li>
<li><a href="#敘述統計">敘述統計</a><ul>
<li><a href="#表三各變數敘述統計量">表三、各變數敘述統計量</a></li>
<li><a href="#表四各產業之市場分類結構">表四、各產業之市場分類結構</a></li>
</ul>
</li>
<li><a href="#相關係數分析">相關係數分析</a><ul>
<li><a href="#表五各變數之pearson相關係數表以etr為應變數">表五、各變數之Pearson相關係數表(以ETR為應變數)</a></li>
<li><a href="#表六各變數之pearson相關係數表以cashetr為應變數">表六、各變數之Pearson相關係數表(以CashETR為應變數)</a></li>
<li><a href="#表七實證結果表">表七、實證結果表</a></li>
</ul>
</li>
</ul>
</li>
<li><a href="#explain">Explain</a></li>
</ul>
</li>
<li><a href="#qa">Q&amp;A</a><ul>
<li><a href="#如何開啟tej增益集">如何開啟TEJ增益集?</a></li>
<li><a href="#自記錄檔匯入tej設定">自記錄檔匯入TEJ設定</a></li>
<li><a href="#q3">Q3</a></li>
<li><a href="#q4">Q4</a></li>
<li><a href="#q5">Q5</a></li>
<li><a href="#q6">Q6</a></li>
</ul>
</li>
<li><a href="#後記">後記</a></li>
<li><a href="#引用文獻">引用文獻</a></li>
</ul>
</li>
</ul>
</div>
</p>

<hr>



<h2 id="運行前的準備">運行前的準備</h2>

<p>欲建立運行環境，請先至<a href="https://cran.r-project.org/mirrors.html">R的網站</a>下載新版的R安裝。</p>

<blockquote>
  <ol>
  <li>使用<kbd><strong>Ctrl+F </strong></kbd>搜尋<strong>Taiwan</strong>，並任選一鏡像下載點，或直接<a href="http://ftp.yzu.edu.tw/CRAN/">點此下載</a>。</li>
  <li>請選擇適合自己電腦運行介面的版本，R提供Linux, Mac及Windows三種版本。</li>
  <li>R支援多國語言，從哪個鏡像下載不影響安裝。</li>
  <li>建議版本需<strong>3.3.0</strong>以後。</li>
  </ol>
</blockquote>

<p>再至<a href="https://www.rstudio.com/">Rstudio官網</a>下載主程式安裝，或<a href="https://www.rstudio.com/products/rstudio/download/">點此</a>至下載頁面。</p>

<blockquote>
  <p>Rstudio載點快速連結：(<strong>0.99.902</strong>版，於2016/5/14更新) <br>
   1. <a href="https://download1.rstudio.org/RStudio-0.99.902.exe">Windows Vista/7/8/10</a> <br>
   2. <a href="https://download1.rstudio.org/RStudio-0.99.902.dmg">Mac OS X 10.6+ (64-bit)</a> <br>
   3. <a href="https://download1.rstudio.org/rstudio-0.99.902-amd64.deb">Ubuntu 12.04+/Debian 8+ (64-bit)</a> <br>
   4. <a href="https://download1.rstudio.org/rstudio-0.99.902-x86_64.rpm">Fedora 19+/RedHat 7+/openSUSE 13.1+ (64-bit)</a></p>
</blockquote>

<hr>



<h2 id="實證分析"><strong>實證分析</strong></h2>



<h3 id="架構"><strong>架構</strong></h3>

<ol>
<li>TEJ資料庫抓取資料建立分析資料庫。<strong>(Getting Data)</strong></li>
<li>整理資料至可使用程度(排除不需要的欄位)。<strong>(Preparing Data)</strong></li>
<li>產生虛擬變數及可供分析建模的變數。<strong>(Produce Variables)</strong></li>
<li>以線性多變量回歸模型分析資料，並製作相關分析表。<strong>(Analyze)</strong></li>
<li>產生報表。<strong>(Produce reports and graphs)</strong></li>
<li>解釋分析結果。<strong>(Explain)</strong></li>
</ol>



<h3 id="getting-data"><strong>Getting Data</strong></h3>

<ol>
<li>開啟Excel，使用TEJ的Excel增益集。 <a href="#如何開啟TEJ增益集">(如何開啟TEJ增益集?)</a></li>
<li>讀入記錄檔，可以得到本分析資料庫的原始設定。</li>
<li>運行RStudio</li>
</ol>



<h3 id="preparation-for-rstudio"><strong>Preparation for RStudio</strong></h3>

<ul>
<li>第一次使用請安裝所需的套件(readxl, data.table, dplyr)</li>
</ul>

<blockquote>
  <p><code>install.packages("readxl")</code>  # 讀入xlsx的套件 <br>
  <code>install.packages("data.table")</code> # 建立資料表的套件 <br>
  <code>install.packages("dplyr")</code> # 文字處理套件</p>
</blockquote>

<ul>
<li>清除環境清單</li>
</ul>

<blockquote>
  <p><code>rm(list=ls())</code> </p>
</blockquote>

<ul>
<li>設定工作資料夾(EX: C:\Users\User\Desktop\Code)</li>
</ul>

<blockquote>
  <p><code>setwd("C:\\Users\\User\\Desktop\\Code")</code> <br>
  <code># 即C槽User使用者的桌面</code></p>
</blockquote>

<ul>
<li>開啟套件 <br>


<blockquote>
  <code>require(readxl)</code> <br>
  <code>require(data.table)</code> <br>
  <code>require(dplyr)</code></blockquote></li>
  </ul>
  


<h3 id="preparing-data"><strong>Preparing Data</strong></h3>

<ul>
<li><p>讀入自TEJ下載的<a href="https://www.dropbox.com/s/3x51hia9z8g9u53/DB.xlsx?dl=0">excel檔</a></p>

<ul><li><p>讀入自行建立的欄位名稱工作表<code>colname_list</code> ，並設定名稱為colattribute</p>

<blockquote>
  <p><code>colattribute &lt;- read_excel(path ="DB.xlsx", sheet = "colname_list", col_names = TRUE)</code></p>
</blockquote></li>
<li><p>讀入</p></li></ul></li>
</ul>

<p>(撰寫中…)</p>



<h3 id="produce-variables"><strong>Produce Variables</strong></h3>



<h3 id="analyze"><strong>Analyze</strong></h3>



<h3 id="produce-reports-and-graphs"><strong>Produce reports and graphs</strong></h3>



<h4 id="樣本說明">樣本說明</h4>



<h5 id="表一樣本篩選表">表一、樣本篩選表</h5>

<blockquote>
  <p><code></code></p>
</blockquote>



<h5 id="表二樣本產業與年度分配表">表二、樣本產業與年度分配表</h5>

<blockquote>
  <p><code></code></p>
</blockquote>



<h5 id="表0按產業年份及變數分類之缺漏值數量表">表0、按產業、年份及變數分類之缺漏值數量表</h5>

<blockquote>
  <p><code></code></p>
</blockquote>



<h4 id="敘述統計">敘述統計</h4>



<h5 id="表三各變數敘述統計量">表三、各變數敘述統計量</h5>

<blockquote>
  <p><code></code></p>
</blockquote>



<h5 id="表四各產業之市場分類結構">表四、各產業之市場分類結構</h5>

<blockquote>
  <p><code></code></p>
</blockquote>



<h4 id="相關係數分析">相關係數分析</h4>



<h5 id="表五各變數之pearson相關係數表以etr為應變數">表五、各變數之Pearson相關係數表(以ETR為應變數)</h5>

<blockquote>
  <p><code></code></p>
</blockquote>



<h5 id="表六各變數之pearson相關係數表以cashetr為應變數">表六、各變數之Pearson相關係數表(以CashETR為應變數)</h5>

<blockquote>
  <p><code></code></p>
</blockquote>



<h5 id="表七實證結果表">表七、實證結果表</h5>

<ul>
<li><p>無STRATEGY*HHI</p>

<blockquote>
  <p><code></code> </p>
</blockquote></li>
<li><p>有STRATEGY*HHI</p>

<blockquote>
  <p><code></code> </p>
</blockquote></li>
</ul>



<h3 id="explain"><strong>Explain</strong></h3>

<blockquote>
  <p><code>解釋</code></p>
</blockquote>

<hr>



<h2 id="qa">Q&amp;A</h2>



<h3 id="如何開啟tej增益集"><strong>如何開啟TEJ增益集?</strong></h3>

<blockquote>
  <ol>
  <li>開啟Excel</li>
  <li>點選左上方<kbd>檔案</kbd> ⇒ <kbd>選項</kbd></li>
  <li>點選彈出視窗左方<kbd>增益集</kbd> ⇒  <strong>管理：Excel增益集</strong> <kbd>執行</kbd></li>
  <li>:white_check_mark: <strong>Excel03Menu</strong> ⇒ <kbd>確定</kbd></li>
  <li>點選上方工具列的<kbd>增益集</kbd> ⇒ <kbd>TEJToolBar:Database setting</kbd></li>
  <li>登入方式參照<a href="http://140.136.208.107/download/proxy.htm">圖書館網站</a>。</li>
  </ol>
</blockquote>



<h3 id="自記錄檔匯入tej設定"><strong>自記錄檔匯入TEJ設定</strong></h3>

<blockquote>
  <ol>
  <li>開啟TEJ Smart Wizard(增益集)</li>
  <li>點選<kbd>檔案管理</kbd> ⇒ <kbd>載入</kbd></li>
  <li>開啟後至<kbd>查詢條件設定</kbd>檢查年份區間等是否設定正確</li>
  <li><kbd>匯出</kbd></li>
  </ol>
</blockquote>



<h3 id="q3"><strong>Q3</strong></h3>



<h3 id="q4"><strong>Q4</strong></h3>



<h3 id="q5"><strong>Q5</strong></h3>



<h3 id="q6"><strong>Q6</strong></h3>



<h2 id="後記">後記</h2>



<h2 id="引用文獻">引用文獻</h2>