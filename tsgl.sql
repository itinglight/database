drop database tsgl;
create database tsgl;

use tsgl;

create table book
(图书编号 char(8) primary key,
图书名称 varchar(20),
作者 varchar(8),
出版社名称 varchar(30),
出版日期 datetime,
定价 float(2));

create table reader
(借书证号  char(6) primary key,
姓名 varchar(8),
性别 char(2),
年龄 int,
联系电话 char(11));

create table borrow
(借书证号  char(6),
图书编号 char(8),
借阅时间 datetime,
还书日期 datetime,  primary  key(借书证号,图书编号));


insert into book values('GBZT0001','计算机网络技术','王靖','清华大学出版社','2011-9-01',28.00);
insert into book values('GBZT0002','数据库应用技术','李奇','人民邮电出版社','2010-1-01',32.80);
insert into book values('GBZT0003','大学英语','刘云','机械工业出版社','2012-2-01',22.00);
insert into book values('GBZT0004','Web技术','孙楠','哈尔滨工业大学出版社','2011-6-01',25.60);
insert into book values('GBZT0005','操作系统基础','吴晓丹','科学出版社','2010-1-01',30.00);
insert into book values('GBZT0006','计算机安全技术','赵小乐','高等教育出版社','2011-3-01',33.50);

insert into reader values('JY0001','孙小雨','女',20,'13812103230');
insert into reader values('JY0002','李立华','男',25,'13713153890');
insert into reader values('JY0003','于娟娟','女',19,'15923173651');
insert into reader values('JY0004','周新','男',21,'15856123213');
insert into reader values('JY0005','张彤','女',23,'15052212666');
insert into reader values('JY0006','胡东','男',18,'15256987233');


insert into borrow values('JY0001','GBZT0003','2011-9-25','2011-11-12');
insert into borrow (借书证号,图书编号,借阅时间) values('JY0002','GBZT0002','2011-10-23');
insert into borrow values('JY0003','GBZT0005','2012-2-26','2012-3-28');
insert into borrow values('JY0004','GBZT0006','2011-11-2','2011-12-12');
insert into borrow (借书证号,图书编号,借阅时间) values('JY0005','GBZT0004','2012-5-15');
insert into borrow (借书证号,图书编号,借阅时间) values('JY0006','GBZT0001','2012-5-9');

# 查询一
# 1、查询“清华大学出版社”出版的所有图书信息；
    select *
    from book
    where 出版社名称 like '清华大学出版社';
# 2、查询“孙小雨”所借图书信息；
    #连接查询
    select  book.*
    from reader,book,borrow
    where reader.借书证号 = borrow.借书证号 and borrow.图书编号=book.图书编号 and reader.姓名='孙小雨';
    #嵌套查询
    select book.*
    from book
    where 图书编号 in (
        select 图书编号
        from borrow
        where 借书证号 in (
            select 借书证号
            from reader
            where 姓名='孙小雨'
            )
        );
# 3、查询“数据库应用技术”的借阅者姓名；
    #连接查询
    select reader.姓名
    from reader,borrow,book
    where reader.借书证号 = borrow.借书证号 and borrow.图书编号=book.图书编号 and book.图书名称='数据库应用技术';
    #嵌套查询
    select reader.姓名
    from reader
    where 借书证号 in(
        select 借书证号
        from borrow
        where 图书编号 in(
            select 图书编号
            from book
            where book.图书名称='数据库应用技术'
            )
        );
# 4、查询所有姓李的读者信息；
    select *
    from reader
    where 姓名 like '李%';
# 5、查询借书证号为“JY0004”的读者所借书名；
    #连接查询
    select 图书名称
    from book,borrow
    where borrow.图书编号=book.图书编号 and 借书证号='JY0004';
    # 嵌套查询
    select 图书名称
    from book
    where 图书编号 in(
        select 图书编号
        from borrow
        where 借书证号='JY0004'
        );
# 6、按定价由高到低列出所有图书名称；
    select 图书名称
    from book
    order by 定价;
# 7、列出所有未还的图书名称；
    #连接查询
    select 图书名称
    from book,borrow
    where book.图书编号=borrow.图书编号 and 还书日期 is null ;
    #嵌套查询
    select 图书名称
    from book
    where 图书编号 in(
        select 图书编号
        from borrow
        where 还书日期 is null
        );
# 8、列出周新同学所借书目的名称及定价。
    #连接查询
    select 图书名称,定价
    from book,reader,borrow
    where reader.借书证号=borrow.借书证号 and borrow.图书编号=book.图书编号 and reader.姓名='周新';
    #嵌套查询
    select 图书名称,定价
    from book
    where 图书编号 in(
        select 图书编号
        from borrow
        where 借书证号 in(
            select 借书证号
            from reader
            where 姓名='周新'
            )
        );

# 查询二
# 1、查询book表中图书编号、名称和出版社；
    select 图书编号,图书名称,出版社名称
    from book;

# 2、查询book表中图书的所有信息。
    select *
    from book;
# 3、查询reader表中的读者信息。
    select *
    from reader;
# 4、查询book表中图书的出版社，要求消除重复内容。
    select distinct 出版社名称
    from book;

# 5、查询book表中图书的图书编号、书名和定价，要求只显示前三行数据。
    select 图书编号,图书名称,定价
    from book
    limit 3;
# 6、查询book表中图书的编号、书名及定价，要求只 显示前30%的数据行。

    #sqlserver 用法
    # select top 10 percent 图书编号,图书名称,定价
    # from book

# 7、查询book表中图书的编号、书名及定价，以"book_id","book_name","book_price"作为显示列名。
    select 图书编号 as book_id,图书名称 as book_name ,定价 as book_price
    from book;
# 8、查询book表中图书的名称，要求显示格式如“图书名称为：大学英语“。
    #MySQL
    select concat('图书名称为:',图书名称) as 图书名称
    from book;
    #sql server
# 9、查询book表中图书的最高定价、最低价格和平均定价。
    select max(定价) as 最高定价,min(定价) as 最低价格,avg(定价) as 平均定价
    from book;
# 10、查询reader表中最小的读者年龄。
    select min(年龄)
    from reader;
# 11、查询book表中图书名为《大学英语》的出版社和定价。
    select 出版社名称,定价
    from book
    where 图书名称='大学英语';
# 12、查询book表中图书的价格高于50元的图书名称、出版社及定价。
    select 图书名称,出版社名称,定价
    from book
    where 定价>50;
# 13、查询book表中清华大学出版社出版的价格低于30的图书名称及定价。
    select 图书名称,定价
    from book
    where 出版社名称='清华大学出版社';
# 14、查询reader表中年龄大于20或性别为女的读者姓名、性别及年龄。
    select 姓名,性别,年龄
    from reader
    where 年龄 >20 or 性别='女';
# 15、查询book表中清华大学出版社、人民邮电出版社和高等教育出版社出版的图书名称和价格。
    select  图书名称,定价
    from book
    where 出版社名称='清华大学出版社' or 出版社名称='人民邮电出版社'or 出版社名称='高等教育出版社';
# 16、查询reader表中借书证号不为JY0001，JY0003，JY0005的读者的借书证号和姓名。
    select 借书证号,姓名
    from reader
    where 借书证号<>'JY0001'and 借书证号<>'JY0003' and 借书证号<>'JY0005';
# 17、查询book表中图书定价在30-50（包含30和50）之间的图书名称和定价。
    #>=,<=
    select 图书名称,定价
    from book
    where 定价 >=30 and 定价 <=50;
    #between
    select 图书名称,定价
    from book
    where 定价 between 30 and 50;
# 18、查询reader表中年龄在18-22（不包含18和22）之间的读者姓名和年龄。
    select 姓名,年龄
    from reader
    where 年龄 >18 and 年龄<22;

# 19、查询book表中图书名称中包含“网络”的图书编号、名称和定价。
    select  图书编号,图书名称,图书名称
    from book
    where 图书名称 like '%网络%';
# 20、查询reader表中张姓读者的姓名和年龄。
    select  姓名,年龄
    from reader
    where 姓名 like '张%';
# 21、查询book表中图书名称、出版社和定价，查询结果按定价降序显示。
    select 图书名称,出版社名称,定价
    from book
    order by 定价 desc;
# 22、查询book表中中图书名称和出版日期。查询结果按出版日期升序显示。
    select 图书名称,出版日期
    from book
    order by 出版日期;
# 23、查询reader表中读者的姓名和性别，结果按性别降序显示。
    select 姓名,性别
    from reader
    order by 性别 desc;
# 24、查询book表中人民邮电出版社出版的图书名称和定价，结果按定价升序显示。
    select 图书名称,定价
    from book
    where 出版社名称='人民邮电出版社'
    order by 定价;
# 25、查询reader表中年龄大于25的读者姓名、性别和年龄，查询结果按性别升序显示。
    select 姓名,性别,年龄
    from reader
    where 年龄>25
    order by 性别;

#查询三
# 1、按出版社分别查询book表中每个出版社出版的图书数量。
    select 出版社名称,count('图书编号')
    from book
    group by 出版社名称;
# 2、按出版社分别查询book表中每个出版社出版定价低于35元的图书数量。
    select 出版社名称,count('图书编号')
    from book
    where 定价<35
    group by 出版社名称;
# 3、按性别分别查询reader表中男、女读者的人数。
    select count('性别') as '男',6-count('性别') as '女'
    from reader
    where 性别='男';
    #group by
    select 性别,count(性别)
    from  reader
    group by 性别;
# 4、按性别分别查询reader表中年龄大于20的男、女读者的人数。
    select 性别,count(借书证号)
    from reader
    where 年龄>20
    group by 性别;
# 5、统计每个读者借书的本数。
    select 姓名,count(图书编号) as '借书的本数'
    from reader,borrow
    where reader.借书证号=borrow.借书证号
    group by 姓名;
# 6、查询借书数目在2本及以上的读者姓名。
    select 姓名
    from reader,borrow
    where borrow.借书证号=reader.借书证号
    group by reader.借书证号,姓名
    having count(borrow.图书编号)>=2;
# 7、查询读者周欣的借书证号和还书时间。

# 8、查询图书编号为GBZT0002的图书名称和借阅日期。

# 9、查询借书证号为JY0005的读者姓名、性别和还书日期。

# 10、查询book表中定价高于平均定价的图书名称和出版社。

# 11、查询reader表中年龄低于平均年龄的读者姓名和性别。

# 12、查询reader表中年龄低于平均年龄的男读者的姓名和性别。

# 13、若book表中图书编号为GBZT0003的图书存在，显示其图书名称、出版社和定价。（用exists)

# 14、判断reader表中借书证号为JY0010的读者是否存在，若存在，显示其姓名和性别。（用exists)

# 15、查询book表中定价最高的那本书的名称及出版社。

# 16、查询book表中每个出版社出版的图书的平均价格。

# 17、查询book表中定价高于平均价格的图书的编号、名称及定价。

# 18、查询所有女读者所借阅的图书名称。

# 19、查询借阅了定价最高的那本图书的读者姓名。

# 20、查询数据库应用技术的借阅者姓名。
