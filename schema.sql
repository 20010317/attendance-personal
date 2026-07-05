-- ============================================================
-- お知らせテーブル(新規)
-- ============================================================
create table announcements (
  id bigint generated always as identity primary key,
  date date not null,
  title text not null,
  body text not null,
  created_at timestamptz default now()
);
alter table announcements enable row level security;
create policy allow_all_anon on announcements for all using (true) with check (true);

-- 初期のお知らせを2件登録
insert into announcements (date, title, body) values
('2026-07-01', '夏季休暇の申請について', '8月のお盆期間の休暇希望は、7月20日までに勤怠システムより申請してください。今年度は分散取得にご協力をお願いします。'),
('2026-07-01', 'お知らせ閲覧システムの変更について', 'システム変更のため、6月分までのお知らせはアプリ上でご覧いただけません。確認が必要な場合は人事課までご連絡ください。');


-- ============================================================
-- 共有設定テーブル(新規)
-- 目標勤務時間(monthlyTargetHours)・お知らせ既読状態(readAnnouncements)などを
-- 全端末で共有するために使用します。
-- 会社名・お名前・社員番号はプライバシーに関わるため、このテーブルには一切保存されません。
-- (各端末のブラウザのlocalStorageにのみ保存されます)
-- ============================================================
create table settings (
  key text primary key,
  value text
);
alter table settings enable row level security;
create policy allow_all_anon on settings for all using (true) with check (true);


-- ============================================================
-- 勤怠打刻テーブル(既存)
-- 既存データを削除・再作成せず、制約とポリシーのみを安全に更新します。
-- ============================================================
alter table stamps alter column created_at set not null;

drop policy if exists "allow all for anon" on stamps;
create policy allow_all_anon on stamps for all to anon using (true) with check (true);
