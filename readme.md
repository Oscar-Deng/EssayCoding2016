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
<li><a href="#r說明檔">R說明檔</a></li>
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
   3. <a href="https://download1.rstudio.org/rstudio-0.99.902-amd64.deb">Ubuntu 12.04+/Debian 8+ (64-bit)</a></p>
</blockquote>

<p>安裝完成後，請確認Rstudio或RGui之語言及區域(language &amp; locale)設定正確：</p>

<blockquote>
  <p>查看環境設定 <br>
  <code>sessionInfo()</code></p>
  
  <p>查看語言/地區設定 <br>
  <code>Sys.getlocale(category = "LC_ALL")</code> <br>
  <code>[1]"LC_COLLATE=Chinese (Traditional)_Taiwan.950;LC_MONETARY=Chinese (Traditional)_Taiwan.950;LC_NUMERIC=C;LC_TIME=Chinese (Traditional)_Taiwan.950" #  若上述回傳非顯示相同值，請輸入下方設定</code></p>
  
  <p><code>Sys.setlocale("LC_ALL",locale='cht')</code></p>
</blockquote>

<p>其他疑難排解，請見手冊： <br>
<a href="https://github.com/dspim/R/wiki/R-&amp;-RStudio-Troubleshooting-Guide">https://github.com/dspim/R/wiki/R-&amp;-RStudio-Troubleshooting-Guide</a></p>

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
<li>讀入記錄檔.dat，可以得到本分析資料庫的原始設定。</li>
<li>運行RStudio</li>
</ol>

<h3 id="preparation-for-rstudio"><strong>Preparation for RStudio</strong></h3>

<blockquote>
  <p>#清除環境清單 <br>
  <code>rm(list=ls())</code> </p>
  
  <p>#設定工作資料夾(EX: C:\Users\User\Desktop\Code) <br>
  <code>setwd("C:\\Users\\User\\Desktop\\Code")</code></p>
  
  <p>#讀入函數庫 <br>
  <code>source('functions.R',encoding='utf-8')</code></p>
  
  <p>#安裝所有未安裝之套件 <br>
  <code>Install.pack()</code> </p>
  
  <p>#讀入所有需要之套件 <br>
  <code>Load.pack()</code> </p>
  
  <p>#擷取工作路徑，用於之後輸出資料庫 <br>
  <code>wd &lt;- getwd()</code> </p>
  
  <p>#清除環境清單 <br>
  <code>rm(list=ls())</code> </p>
</blockquote>

<h3 id="preparing-data"><strong>Preparing Data</strong></h3>

<ol>
<li><p>讀入自TEJ下載的<a href="https://github.com/Oscar-Deng/EssayCoding2016/blob/master/DB2.xlsx">excel檔</a>，並命名為<code>TEJ</code>資料集。</p>

<blockquote>
  <p><code>TEJ &lt;- readDB(fil = "DB2.xlsx", attr_sht = "TEJ_attr", xls_sht = "TEJ")</code></p>
</blockquote></li>
<li><p>篩選資料集TEJ，並命為<code>TEJ0</code>，同時將篩選掉的資料集另命為<code>TEJ01</code>。</p>

<blockquote>
  <p><code>TEJ0 &lt;- DBfilter(x = TEJ,filt = 'filtered')</code> <br>
  <code>TEJ01 &lt;- DBfilter(x = TEJ,filt = 'dropped')</code></p>
</blockquote></li>
<li><p>1</p></li>
<li>1</li>
<li>1</li>
<li>1</li>
<li>1</li>
<li>1</li>
<li>1</li>
<li>1</li>
<li>1</li>
<li>1 </li>
</ol>

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

<ul>
<li><a href="http://stackoverflow.com/">http://stackoverflow.com/</a></li>
<li><a href="http://stackoverflow.com/questions/31351958/data-table-in-r-filtering-by-multiple-keys-using-binary-search">http://stackoverflow.com/questions/31351958/data-table-in-r-filtering-by-multiple-keys-using-binary-search</a></li>
<li><a href="http://stackoverflow.com/questions/9368900/how-to-check-if-object-variable-is-defined-in-r">http://stackoverflow.com/questions/9368900/how-to-check-if-object-variable-is-defined-in-r</a></li>
<li><a href="http://stackoverflow.com/questions/10276092/to-find-whether-a-column-exists-in-data-frame-or-not">http://stackoverflow.com/questions/10276092/to-find-whether-a-column-exists-in-data-frame-or-not</a></li>
<li><a href="http://stackoverflow.com/questions/9970116/ignoring-values-or-nas-in-the-sample-function">http://stackoverflow.com/questions/9970116/ignoring-values-or-nas-in-the-sample-function</a></li>
<li><a href="http://stackoverflow.com/questions/6229824/winsorize-dataframe">http://stackoverflow.com/questions/6229824/winsorize-dataframe</a>   </li>
<li><a href="http://stackoverflow.com/questions/24886686/r-winsorizing-robust-hd-not-compatible-with-nas">http://stackoverflow.com/questions/24886686/r-winsorizing-robust-hd-not-compatible-with-nas</a></li>
<li><a href="http://stackoverflow.com/questions/20105015/summing-lots-of-vectors-row-wise-or-elementwise-but-ignoring-na-values">http://stackoverflow.com/questions/20105015/summing-lots-of-vectors-row-wise-or-elementwise-but-ignoring-na-values</a></li>
<li><a href="http://stackoverflow.com/questions/5031630/how-to-source-r-file-saved-using-utf-8-encoding">http://stackoverflow.com/questions/5031630/how-to-source-r-file-saved-using-utf-8-encoding</a></li>
<li><a href="http://stackoverflow.com/questions/13763216/how-can-i-remove-all-duplicates-so-that-none-are-left-in-a-data-frame-in-r">http://stackoverflow.com/questions/13763216/how-can-i-remove-all-duplicates-so-that-none-are-left-in-a-data-frame-in-r</a></li>
<li><a href="http://stackoverflow.com/questions/7072159/how-do-you-remove-columns-from-a-data-frame">http://stackoverflow.com/questions/7072159/how-do-you-remove-columns-from-a-data-frame</a></li>
<li><a href="http://stackoverflow.com/questions/5391124/in-r-select-rows-of-a-matrix-that-meet-a-condition">http://stackoverflow.com/questions/5391124/in-r-select-rows-of-a-matrix-that-meet-a-condition</a></li>
<li><a href="http://stackoverflow.com/questions/19889303/r-force-a-subset-of-a-data-frame-to-remain-as-a-data-frame">http://stackoverflow.com/questions/19889303/r-force-a-subset-of-a-data-frame-to-remain-as-a-data-frame</a></li>
<li><a href="http://stackoverflow.com/questions/35852776/skip-nas-with-rollapplyr">http://stackoverflow.com/questions/35852776/skip-nas-with-rollapplyr</a></li>
<li><a href="http://stackoverflow.com/questions/18435338/print-or-capturing-multiple-objects-in-r">http://stackoverflow.com/questions/18435338/print-or-capturing-multiple-objects-in-r</a></li>
<li><a href="http://stackoverflow.com/questions/4090169/elegant-way-to-check-for-missing-packages-and-install-them">http://stackoverflow.com/questions/4090169/elegant-way-to-check-for-missing-packages-and-install-them</a></li>
<li><a href="http://stackoverflow.com/questions/17891359/in-what-order-does-cat-choose-files-to-display">http://stackoverflow.com/questions/17891359/in-what-order-does-cat-choose-files-to-display</a></li>
<li><a href="http://stackoverflow.com/questions/14260340/function-to-clear-the-console-in-r">http://stackoverflow.com/questions/14260340/function-to-clear-the-console-in-r</a></li>
<li><a href="http://stackoverflow.com/questions/1405571/how-to-assign-output-of-cat-to-an-object">http://stackoverflow.com/questions/1405571/how-to-assign-output-of-cat-to-an-object</a></li>
<li><a href="http://stackoverflow.com/questions/3926106/how-to-use-apply-cat-and-print-without-getting-null">http://stackoverflow.com/questions/3926106/how-to-use-apply-cat-and-print-without-getting-null</a></li>
<li><a href="http://stackoverflow.com/questions/7201341/how-can-2-strings-be-concatenated-in-r">http://stackoverflow.com/questions/7201341/how-can-2-strings-be-concatenated-in-r</a></li>
<li><a href="http://stackoverflow.com/questions/37972147/eval-function-in-r">http://stackoverflow.com/questions/37972147/eval-function-in-r</a></li>
<li><a href="http://stackoverflow.com/questions/32520808/r-parse-and-evaluate-variable-names-within-a-function">http://stackoverflow.com/questions/32520808/r-parse-and-evaluate-variable-names-within-a-function</a></li>
<li><a href="http://stackoverflow.com/questions/36404576/r-eval-parse-character-limit">http://stackoverflow.com/questions/36404576/r-eval-parse-character-limit</a></li>
<li><a href="http://stackoverflow.com/questions/8175912/load-multiple-packages-at-once">http://stackoverflow.com/questions/8175912/load-multiple-packages-at-once</a></li>
<li><a href="http://stackoverflow.com/questions/18306362/run-r-script-from-command-line">http://stackoverflow.com/questions/18306362/run-r-script-from-command-line</a></li>
<li><a href="http://stackoverflow.com/questions/31896113/clueless-about-this-error-wrong-sign-in-by-argument">http://stackoverflow.com/questions/31896113/clueless-about-this-error-wrong-sign-in-by-argument</a></li>
<li><a href="http://stackoverflow.com/questions/4605206/drop-data-frame-columns-by-name">http://stackoverflow.com/questions/4605206/drop-data-frame-columns-by-name</a></li>
<li><a href="http://stackoverflow.com/questions/9202413/how-do-you-delete-a-column-by-name-in-data-table">http://stackoverflow.com/questions/9202413/how-do-you-delete-a-column-by-name-in-data-table</a></li>
<li><a href="http://stackoverflow.com/questions/19379081/how-to-replace-na-values-in-a-table-for-selected-columns-data-frame-data-tab">http://stackoverflow.com/questions/19379081/how-to-replace-na-values-in-a-table-for-selected-columns-data-frame-data-tab</a></li>
<li><a href="http://stackoverflow.com/questions/18562680/replacing-nas-with-0s-in-r-dataframe">http://stackoverflow.com/questions/18562680/replacing-nas-with-0s-in-r-dataframe</a></li>
<li><a href="http://stackoverflow.com/questions/6244217/subsetting-a-dataframe-in-r-by-multiple-conditions">http://stackoverflow.com/questions/6244217/subsetting-a-dataframe-in-r-by-multiple-conditions</a></li>
<li><a href="http://stackoverflow.com/questions/4935479/how-to-combine-multiple-conditions-to-subset-a-data-frame-using-or">http://stackoverflow.com/questions/4935479/how-to-combine-multiple-conditions-to-subset-a-data-frame-using-or</a></li>
<li><a href="http://stackoverflow.com/questions/8161836/how-do-i-replace-na-values-with-zeros-in-r">http://stackoverflow.com/questions/8161836/how-do-i-replace-na-values-with-zeros-in-r</a></li>
<li><a href="http://stackoverflow.com/questions/19409550/rank-and-length-with-missing-values-in-r">http://stackoverflow.com/questions/19409550/rank-and-length-with-missing-values-in-r</a></li>
<li><a href="http://stackoverflow.com/questions/18302610/remove-ids-that-occur-x-times-r">http://stackoverflow.com/questions/18302610/remove-ids-that-occur-x-times-r</a></li>
<li><a href="http://stackoverflow.com/questions/23727702/how-to-count-the-number-of-observations-in-r-like-stata-command-count">http://stackoverflow.com/questions/23727702/how-to-count-the-number-of-observations-in-r-like-stata-command-count</a></li>
<li><a href="http://stackoverflow.com/questions/17573226/generating-a-moving-sum-variable-in-r?answertab=active#tab-top">http://stackoverflow.com/questions/17573226/generating-a-moving-sum-variable-in-r?answertab=active#tab-top</a></li>
<li><a href="http://stackoverflow.com/questions/36190503/running-sum-in-r-data-table/36190577">http://stackoverflow.com/questions/36190503/running-sum-in-r-data-table/36190577</a></li>
<li><a href="http://stackoverflow.com/questions/31896113/clueless-about-this-error-wrong-sign-in-by-argument">http://stackoverflow.com/questions/31896113/clueless-about-this-error-wrong-sign-in-by-argument</a></li>
<li><a href="http://stackoverflow.com/questions/17607014/rollapply-wrong-sign-in-by-argument-for-single-row-data-frame">http://stackoverflow.com/questions/17607014/rollapply-wrong-sign-in-by-argument-for-single-row-data-frame</a></li>
<li><a href="http://stackoverflow.com/questions/743812/calculating-moving-average-in-r">http://stackoverflow.com/questions/743812/calculating-moving-average-in-r</a></li>
<li><a href="http://stackoverflow.com/questions/19327020/in-r-how-to-split-subset-a-data-frame-by-factors-in-one-column">http://stackoverflow.com/questions/19327020/in-r-how-to-split-subset-a-data-frame-by-factors-in-one-column</a></li>
<li><a href="http://stackoverflow.com/questions/9704213/r-remove-part-of-string">http://stackoverflow.com/questions/9704213/r-remove-part-of-string</a></li>
<li><a href="http://stackoverflow.com/questions/8491754/converting-different-rows-of-a-data-frame-to-one-single-row-in-r">http://stackoverflow.com/questions/8491754/converting-different-rows-of-a-data-frame-to-one-single-row-in-r</a></li>
<li><a href="http://stackoverflow.com/questions/17513109/calculating-mean-when-2-conditions-need-met-in-r">http://stackoverflow.com/questions/17513109/calculating-mean-when-2-conditions-need-met-in-r</a></li>
<li><a href="http://stackoverflow.com/questions/25598361/calculating-row-entry-conditional-on-value-in-another-column-in-r">http://stackoverflow.com/questions/25598361/calculating-row-entry-conditional-on-value-in-another-column-in-r</a></li>
</ul>

<p>……</p>

<p><a href="http://stats.stackexchange.com/questions/6759/removing-duplicated-rows-data-frame-in-r">http://stats.stackexchange.com/questions/6759/removing-duplicated-rows-data-frame-in-r</a> <br>
<a href="http://www.r-bloggers.com/winsorization/">http://www.r-bloggers.com/winsorization/</a> <br>
<a href="http://www.inside-r.org/packages/cran/robustHD/docs/winsorize">http://www.inside-r.org/packages/cran/robustHD/docs/winsorize</a> <br>
<a href="http://www.programiz.com/r-programming/if-else-statement">http://www.programiz.com/r-programming/if-else-statement</a> <br>
<a href="http://italwaysrainonme.blogspot.tw/2013/01/git-gitignore-commit.html">http://italwaysrainonme.blogspot.tw/2013/01/git-gitignore-commit.html</a> <br>
<a href="http://huan-lin.blogspot.com/2012/04/git-ignore-file.html">http://huan-lin.blogspot.com/2012/04/git-ignore-file.html</a> <br>
<a href="http://www.r-tutor.com/r-introduction/data-frame">http://www.r-tutor.com/r-introduction/data-frame</a></p>

<ul>
<li><a href="https://stat.ethz.ch/">https://stat.ethz.ch/</a></li>
<li><a href="https://stat.ethz.ch/pipermail/r-help/2002-April/020794.html">https://stat.ethz.ch/pipermail/r-help/2002-April/020794.html</a></li>
<li><a href="https://stat.ethz.ch/R-manual/R-devel/library/stats/html/sd.html">https://stat.ethz.ch/R-manual/R-devel/library/stats/html/sd.html</a></li>
<li><a href="https://stat.ethz.ch/R-manual/R-devel/library/base/html/sample.html">https://stat.ethz.ch/R-manual/R-devel/library/base/html/sample.html</a></li>
<li><a href="https://stat.ethz.ch/R-manual/R-devel/library/graphics/html/plot.html">https://stat.ethz.ch/R-manual/R-devel/library/graphics/html/plot.html</a></li>
<li><a href="https://stat.ethz.ch/R-manual/R-devel/library/utils/html/write.table.html">https://stat.ethz.ch/R-manual/R-devel/library/utils/html/write.table.html</a></li>
<li><a href="https://stat.ethz.ch/R-manual/R-devel/library/base/html/print.dataframe.html">https://stat.ethz.ch/R-manual/R-devel/library/base/html/print.dataframe.html</a></li>
<li><a href="https://stat.ethz.ch/R-manual/R-devel/library/base/html/Extract.data.frame.html">https://stat.ethz.ch/R-manual/R-devel/library/base/html/Extract.data.frame.html</a></li>
<li><a href="https://stat.ethz.ch/R-manual/R-devel/library/base/html/table.html">https://stat.ethz.ch/R-manual/R-devel/library/base/html/table.html</a></li>
<li><a href="https://stat.ethz.ch/R-manual/R-devel/library/base/html/merge.html">https://stat.ethz.ch/R-manual/R-devel/library/base/html/merge.html</a></li>
<li><a href="https://stat.ethz.ch/pipermail/r-help/2011-August/285614.html">https://stat.ethz.ch/pipermail/r-help/2011-August/285614.html</a></li>
</ul>

<p><a href="http://www.statmethods.net/input/missingdata.html">http://www.statmethods.net/input/missingdata.html</a> <br>
<a href="http://www.statmethods.net/advgraphs/layout.html">http://www.statmethods.net/advgraphs/layout.html</a> <br>
<a href="http://www.inside-r.org/r-doc/stats/rnorm">http://www.inside-r.org/r-doc/stats/rnorm</a> <br>
<a href="http://www.inside-r.org/packages/cran/robustHD/docs/winsorize">http://www.inside-r.org/packages/cran/robustHD/docs/winsorize</a></p>

<p><a href="http://www.tej.com.tw/webtej/doc/wind1.htm">http://www.tej.com.tw/webtej/doc/wind1.htm</a> <br>
<a href="http://web.ntpu.edu.tw/~cflin/Teach/R/R06EN06Graphics.pdf">http://web.ntpu.edu.tw/~cflin/Teach/R/R06EN06Graphics.pdf</a></p>

<h2 id="r說明檔">R說明檔</h2>

<ul>
<li><a href="https://cran.r-project.org/doc/contrib/Liu-FAQ.pdf">https://cran.r-project.org/doc/contrib/Liu-FAQ.pdf</a></li>
<li><a href="https://cran.r-project.org/web/packages/dplyr/dplyr.pdf">https://cran.r-project.org/web/packages/dplyr/dplyr.pdf</a></li>
<li><a href="https://cran.r-project.org/web/packages/data.table/data.table.pdf">https://cran.r-project.org/web/packages/data.table/data.table.pdf</a></li>
<li><a href="https://cran.r-project.org/web/packages/robustHD/robustHD.pdf">https://cran.r-project.org/web/packages/robustHD/robustHD.pdf</a></li>
<li><a href="https://cran.r-project.org/web/packages/WriteXLS/WriteXLS.pdf">https://cran.r-project.org/web/packages/WriteXLS/WriteXLS.pdf</a></li>
<li><a href="https://cran.r-project.org/web/packages/readxl/readxl.pdf">https://cran.r-project.org/web/packages/readxl/readxl.pdf</a></li>
<li><a href="https://cran.r-project.org/web/packages/knitr/knitr.pdf">https://cran.r-project.org/web/packages/knitr/knitr.pdf</a></li>
<li><a href="https://cran.r-project.org/web/packages/sampling/sampling.pdf">https://cran.r-project.org/web/packages/sampling/sampling.pdf</a></li>
<li><a href="https://cran.r-project.org/web/packages/xts/xts.pdf">https://cran.r-project.org/web/packages/xts/xts.pdf</a></li>
<li><a href="https://cran.r-project.org/web/packages/astsa/astsa.pdf">https://cran.r-project.org/web/packages/astsa/astsa.pdf</a></li>
<li><a href="https://cran.r-project.org/web/packages/zoo/zoo.pdf">https://cran.r-project.org/web/packages/zoo/zoo.pdf</a></li>
<li><a href="https://cran.r-project.org/web/packages/R.oo/R.oo.pdf">https://cran.r-project.org/web/packages/R.oo/R.oo.pdf</a></li>
<li><a href="https://cran.r-project.org/web/packages/R.utils/R.utils.pdf">https://cran.r-project.org/web/packages/R.utils/R.utils.pdf</a></li>
<li><a href="https://cran.r-project.org/web/packages/psych/psych.pdf">https://cran.r-project.org/web/packages/psych/psych.pdf</a></li>
<li><a href="https://cran.r-project.org/web/packages/gridExtra/gridExtra.pdf">https://cran.r-project.org/web/packages/gridExtra/gridExtra.pdf</a></li>
 - 
</ul>