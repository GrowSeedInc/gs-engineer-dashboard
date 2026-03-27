/* eslint-disable */
import type { DefineMethods } from 'aspida';
import type * as Types from '../../../@types';

export type Methods = DefineMethods<{
  /** ログインユーザーの受注契約一覧と月別受注状況を返す */
  get: {
    query?: {
      /** 表示開始年月（YYYY-MM形式） */
      from?: string | undefined;
      /** 表示終了年月（YYYY-MM形式） */
      to?: string | undefined;
    } | undefined;

    status: 200;
    /** 取得成功 */
    resBody: Types.ContractList;
  };
}>;
