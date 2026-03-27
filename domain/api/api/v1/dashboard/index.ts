/* eslint-disable */
import type { DefineMethods } from 'aspida';
import type * as Types from '../../../@types';

export type Methods = DefineMethods<{
  /** ログインユーザーの月額給与・月額単価・還元率を返す */
  get: {
    status: 200;
    /** 取得成功 */
    resBody: Types.DashboardSummary;
  };
}>;
