/* eslint-disable */
import type { DefineMethods } from 'aspida';
import type * as Types from '../../../@types';

export type Methods = DefineMethods<{
  /** ログインユーザーの月別還元率推移を返す */
  get: {
    query?: {
      /** 取得開始年月（YYYY-MM形式） */
      from?: string | undefined;
      /** 取得終了年月（YYYY-MM形式） */
      to?: string | undefined;
    } | undefined;

    status: 200;
    /** 取得成功 */
    resBody: Types.ReturnRateTrendList;
  };
}>;
